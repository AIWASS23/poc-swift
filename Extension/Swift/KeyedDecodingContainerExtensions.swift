
import Foundation

extension KeyedDecodingContainer {
    // Try to decode a Bool as Int then String before decoding as Bool.
    
    func decodeBoolAsIntOrString(forKey key: Key) throws -> Bool {
        if let intValue = try? decode(Int.self, forKey: key) {
            return (intValue as NSNumber).boolValue
        } else if let stringValue = try? decode(String.self, forKey: key) {
            return (stringValue as NSString).boolValue
        } else {
            return try decode(Bool.self, forKey: key)
        }
    }

    // Try to decode a Bool as Int then String before decoding as Bool if present.
    
    func decodeBoolAsIntOrStringIfPresent(forKey key: Key) throws -> Bool? {
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return (intValue as NSNumber).boolValue
        } else if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return (stringValue as NSString).boolValue
        } else {
            return try decodeIfPresent(Bool.self, forKey: key)
        }
    }
}
