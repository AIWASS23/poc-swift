import Foundation

class CacheManager {
    let cache = NSCache<NSString, Cache>()
    let status = NSCache<NSString, StatusObject>()
    
    private var networkStatus: NetworkStatus = .connected
    private let dateProvider: () -> Date
    
    
    internal func insert(entry: Cache, for endpoint: Endpoint) {
        cache.setObject(entry, forKey: endpoint.uid.asNSString)
    }
    
    internal func fetch(from endpoint: Endpoint) -> Cache? {
        guard let entry = cache.object(forKey: endpoint.uid.asNSString) else {
            return nil
        }
        
        //Basicly, if our client has lost internet connection we don't want to remove cached data even if it is expired
        //due to obvious reasons
        guard entry.expiresAt > dateProvider() && networkStatus == .connected else {
            return nil
        }
        
        return entry
    }
    
    internal func delete(endpoint: Endpoint) {
        cache.removeObject(forKey: endpoint.uid.asNSString)
    }
    
    ///Removes all cached data which is currently stored in `CacheManager` object
    ///aka `cache` and `status`
    func flush() async {
        cache.removeAllObjects()
    }
    
    func updateNetworkStatus(to status: NetworkStatus) {
        networkStatus = status
    }
    
    init(dateProvider: @escaping () -> Date) {
        self.dateProvider = dateProvider
    }
}

//NSCache must take AnyObject as its parameter
final class Cache: NSDiscardableContent {
    let data: Data
    let expiresAt: Date
    
    func endContentAccess() { }
    func beginContentAccess() -> Bool { return true }
    func isContentDiscarded() -> Bool { return false }
    func discardContentIfPossible() { }
    
    init(data: Data, for expiresIn: TimeInterval) {
        self.data = data
        self.expiresAt = Date().addingTimeInterval(expiresIn)
    }
}

final class StatusObject {
    let status: Status
    
    init(status: Status) {
        self.status = status
    }
}

enum Status {
    case ongoing(Task<Data, Error>)
    case completed
}

struct CachePolicy {
    let shouldCache: Bool
    let shouldExpireIn: TimeInterval
    
    init(shouldCache: Bool = false, shouldExpireIn: TimeInterval = 5) {
        self.shouldCache = shouldCache
        self.shouldExpireIn = shouldExpireIn
    }
}
