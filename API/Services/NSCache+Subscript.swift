import Foundation

extension NSCache where KeyType == NSString, ObjectType == StatusObject {
    subscript(_ endpoint: Endpoint) -> Status? {
        get {
            let key = endpoint.uid.asNSString
            let object = object(forKey: key)
            return object?.status
        }
        set {
            let key = endpoint.uid.asNSString
            if let status = newValue {
                let value = StatusObject(status: status)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
