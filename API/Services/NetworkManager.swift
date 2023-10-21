import Foundation

actor NetworkManager {
    private let cache: CacheManager
    private let keychain: KeychainManager
    
    private var refreshTask: Task<Auth, Error>?
    
    private lazy var decoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        
        return decoder
    }()
    
    //MARK: Authorization
    private var auth: Auth {
        get async throws {
            if let task = refreshTask {
                return try await task.value
            }
        
            guard let accessAuth = keychain[.accessAuth] else {
                throw AuthError.authObjectIsMissing
            }
            
            guard accessAuth.isValid else {
                return try await refresh()
            }
            
            return accessAuth
        }
    }
    
    private func authorize(request: URLRequest) async throws -> URLRequest {
        let auth = try await auth
        var request = request
        request.addValue("Bearer \(auth.token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func refresh() async throws -> Auth {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        
        guard let refreshAuth = keychain[.refreshAuth] else {
            throw AuthError.authObjectIsMissing
        }
        
        guard refreshAuth.isValid else {
            throw AuthError.couldNotRefreshAuthObject
        }
        
        let task = Task { () throws -> Auth in
            defer { refreshTask = nil }
            
            let endpoint = Endpoints.AuthEndpoint.refresh(token: refreshAuth.token)
            return try await response(from: endpoint)
        }
        
        self.refreshTask = task
        return try await task.value
    }
    
    func response<T: Codable>(from endpoint: Endpoint, authorize: Bool = true, retry: Bool = true, policy: CachePolicy = CachePolicy()) async throws -> T {
        if let status = cache.status[endpoint] {
            switch status {
            case .ongoing(let task):
                let data = try await task.value
                return try decoder.decode(T.self, from: data)
            case .completed:
                break
            }
        }
        
        let request = authorize ? try await self.authorize(request: endpoint.request) : endpoint.request
    
        let task = Task<Data, Error> {
            guard let (data, response) = try await URLSession.shared.data(for: request) as? (Data, HTTPURLResponse) else {
                print("INVALID")
                cache.status[endpoint] = .completed
                throw NetworkError.invalidHTTPResponse
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("OUT OF RANGE 12")
                cache.status[endpoint] = .completed
                let response: APIError = try decoder.decode(APIError.self, from: data)
                print(response.description)
                throw NetworkError.failure(statusCode: response.status, message: response.description)
            }
            
            return data
        }
        
        cache.status[endpoint] = .ongoing(task)
        let data = try await task.value
        cache.status[endpoint] = .completed
        
        //TODO: Do not cache if data is not valid
        if policy.shouldCache { cache[endpoint] = Cache(data: data, for: policy.shouldExpireIn)
        
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("ERROR \(error) WHILE DECODING")
            throw NetworkError.invalidHTTPResponse
        }
    }
    
    //TODO: Add -> Some sort of resposne, Kacper did not implemented it yet
    func request(to endpoint: Endpoint, authorize: Bool = true, retry: Bool = true) async throws {
        if let status = cache.status[endpoint] {
            switch status {
            case .ongoing:
                return
            case .completed:
                break
            }
        }
        
        let request = authorize ? try await self.authorize(request: endpoint.request) : endpoint.request
        let task = Task<Data, Error> {
            guard let (data, response) = try await URLSession.shared.data(for: request) as? (Data, HTTPURLResponse) else {
                throw NetworkError.invalidHTTPResponse
            }
            
            guard (200...299).contains( response.statusCode ) else {
                let response: APIError = try decoder.decode(APIError.self, from: data)
                throw NetworkError.failure(statusCode: response.status, message: response.description)
            }
            
            return Data()
        }
        
        cache.status[endpoint] = .ongoing(task)
        let _  = try await task.value
        cache.status[endpoint] = .completed
    }
    
    init(keychainManager: KeychainManager, cacheManager: CacheManager){
        self.cache = cacheManager
        self.keychain = keychainManager
    }
}
