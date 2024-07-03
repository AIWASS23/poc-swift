import Foundation
import Alamofire
import Combine

class ServiceApi {
    
    private let appID: String = "SEU_ID"
    private let appKey: String = "SUA_CHAVE"
    private let baseURL: String = "https://api.edamam.com/api/nutrition-data?"
    private var cancellables = Set<AnyCancellable>()
    
    func getNutritionAnalysisCompletion(
        nutritionType: String,
        value: String,
        unit: String,
        foodParam: String,
        completion: @escaping (NutritionResponseCode?, NutritionResponse?, Error?) -> Void
    ){
        
        // Construir a URL
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "app_id", value: appID),
            URLQueryItem(name: "app_key", value: appKey),
            URLQueryItem(name: "nutrition-type", value: nutritionType),
            URLQueryItem(name: "ingr", value: "\(value) \(unit) \(foodParam)")
        ]
        
        guard let requestURL = urlComponents?.url else {
            print("Error: Unable to create URL")
            DispatchQueue.main.async {
                completion(nil, nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            guard let data = data else {
                print("Error: Data is nil")
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            
            // Print raw data received from the API
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received raw data: \(jsonString)")
            } else {
                print("Failed to convert data to String.")
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(NutritionResponse.self, from: data)
                print(response)
                DispatchQueue.main.async {
                    completion(nil, response, nil)
                }
            } catch {
                do {
                    let responseCode = try decoder.decode(NutritionResponseCode.self, from: data)
                    print(responseCode)
                    DispatchQueue.main.async {
                        completion(responseCode, nil, nil)
                    }
                } catch {
                    print("Failed to Decode Data: \(error.localizedDescription)")
                    print(String(data: data, encoding: .utf8) ?? "No response data")
                    DispatchQueue.main.async {
                        completion(nil, nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func getNutritionAnalysisAsync(
        nutritionType: String,
        value: String,
        unit: String,
        foodParam: String
    ) async throws -> (NutritionResponseCode?, NutritionResponse?) {
        
        // Construir a URL
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "app_id", value: appID),
            URLQueryItem(name: "app_key", value: appKey),
            URLQueryItem(name: "nutrition-type", value: nutritionType),
            URLQueryItem(name: "ingr", value: "\(value) \(unit) \(foodParam)")
        ]
        
        guard let requestURL = urlComponents?.url else {
            print("Error: Unable to create URL")
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }
        
        // Perform the request
        let (data, _) = try await URLSession.shared.data(from: requestURL)
        
        // Print raw data received from the API
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Received raw data: \(jsonString)")
        } else {
            print("Failed to convert data to String.")
        }
        
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(NutritionResponse.self, from: data)
            print(response)
            return (nil, response)
        } catch {
            do {
                let responseCode = try decoder.decode(NutritionResponseCode.self, from: data)
                print(responseCode)
                return (responseCode, nil)
            } catch {
                print("Failed to Decode Data: \(error.localizedDescription)")
                print(String(data: data, encoding: .utf8) ?? "No response data")
                throw error
            }
        }
    }
    
    func getNutritionAnalysisAlamofire(
        nutritionType: String,
        value: String,
        unit: String,
        foodParam: String,
        completion: @escaping (NutritionResponseCode?, NutritionResponse?, Error?) -> Void
    ) {
        // Construir a URL
        let url = baseURL
        let parameters: [String: String] = [
            "app_id": appID,
            "app_key": appKey,
            "nutrition-type": nutritionType,
            "ingr": "\(value) \(unit) \(foodParam)"
        ]
        
        // Realizar a requisição com Alamofire
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: NutritionResponse.self) { response in
                switch response.result {
                case .success(let nutritionResponse):
                    completion(nil, nutritionResponse, nil)
                case .failure(let error):
                    completion(nil, nil, error)
                }
            }
    }
    
    func getNutritionAnalysisCombine(
        nutritionType: String,
        value: String,
        unit: String,
        foodParam: String,
        completion: @escaping (NutritionResponseCode?, NutritionResponse?, Error?) -> Void
    ) {
        // Construir a URL
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "app_id", value: appID),
            URLQueryItem(name: "app_key", value: appKey),
            URLQueryItem(name: "nutrition-type", value: nutritionType),
            URLQueryItem(name: "ingr", value: "\(value) \(unit) \(foodParam)")
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            completion(nil, nil, URLError(.badURL))
            return
        }
        
        // Create a publisher
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: NutritionResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                    let responseCode = NutritionResponseCode(statusCode: (error as? URLError)?.code.rawValue ?? -1, message: error.localizedDescription)
                    completion(responseCode, nil, error)
                }
            }, receiveValue: { nutritionResponse in
                completion(nil, nutritionResponse, nil)
            })
            .store(in: &cancellables)
    }
}
