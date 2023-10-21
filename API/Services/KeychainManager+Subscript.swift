import Foundation

extension KeychainManager {
    subscript(_ key: AuthKey) -> Auth? {
        get { try? self.fetch(key: key) }
        set {
            if let auth = newValue {
                do { try insert(auth, for: key) } catch KeychainError.authObjectExists {
                    do { try update(key: key, with: auth) } catch {
                        print("\(error) occured while updating keychain value for key \(key)")
                    }
                } catch {
                    print("\(error) occured while inserting keychain value for key \(key)")
                }
            } else {
                do { try delete(key: key) } catch {
                    print("\(error) occured while deleting keychain value for key \(key)")
                }
            }
        }
    }
}
