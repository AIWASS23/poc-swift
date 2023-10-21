import Foundation
import Security

final class KeychainManager {
    internal enum AuthKey: String {
        case accessAuth
        case refreshAuth
    }
    
    private func encode(_ auth: Auth) throws -> Data {
        guard let data = try? JSONEncoder().encode(auth) else {
            throw KeychainError.couldNotDecodeAuthObject
        }
        
        return data
    }
    
    private func decode(_ data: Data) throws -> Auth {
        guard let object = try? JSONDecoder().decode(Auth.self, from: data) else {
            throw KeychainError.couldNotEncodeAuthObject
        }
        
        return object
    }
    
     func insert(_ auth: Auth, for key: AuthKey) throws {
        let data = try encode(auth)
        let insertQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ] as CFDictionary
        
        let status = SecItemAdd(insertQuery, nil)
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeychainError.authObjectExists
            }
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
     func fetch(key: AuthKey) throws -> Auth {
        let fetchQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecMatchLimit: 1,
            kSecReturnData: true
        ] as CFDictionary
        
        var data: AnyObject?
        let status = SecItemCopyMatching(fetchQuery, &data)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound { throw KeychainError.authObjectNotFound }
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let object = try? decode(data as! Data) else {
            throw KeychainError.couldNotDecodeAuthObject
        }
        
        return object
    }
    
    func update(key: AuthKey, with auth: Auth) throws {
        let updateQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        let data = try encode(auth)
        let newValue = [
            kSecValueData: data
        ] as CFDictionary
        
        let status = SecItemUpdate(updateQuery, newValue)
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.authObjectNotFound
            }
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func delete(key: AuthKey) throws {
        let deleteQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        let status = SecItemDelete(deleteQuery)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
