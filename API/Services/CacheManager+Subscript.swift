import Foundation

extension CacheManager {
    subscript(_ endpoint: Endpoint) -> Cache? {
        get { fetch(from: endpoint) }
        set {
            if let entry = newValue {
                insert(entry: entry, for: endpoint)
            } else {
                delete(endpoint: endpoint)
            }
        }
    }
}

