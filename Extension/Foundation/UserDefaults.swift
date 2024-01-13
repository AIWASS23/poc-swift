/*

 Essa extensão adiciona suporte para armazenar e recuperar objetos personalizados em UserDefaults usando a codificação
 e decodificação JSON. O código define um wrapper de propriedade chamado UserDefault<T>, que facilita o armazenamento
 e recuperação de valores personalizados em UserDefaults. O wrapper lida automaticamente com a codificação
 e decodificação de objetos usando JSON.

 struct User: Codable {
     var name: String
     var age: Int
 }

 class AppSettings {
     @UserDefault(key: \.currentUser)
     static var currentUser: User?
 }

 extension UserDefaultsKeys {
     var currentUser: String {
         return "currentUserKey"
     }
 }

 // Uso
 let user = User(name: "John", age: 30)

 // Salvando o usuário nas UserDefaults
 AppSettings.currentUser = user

 // Recuperando o usuário das UserDefaults
 if let retrievedUser = AppSettings.currentUser {
     print("User Name: \(retrievedUser.name), Age: \(retrievedUser.age)")
 } else {
     print("User not found.")
 }

 // Resetando a UserDefaults
 UserDefaults.standard.reset(keys: [UserDefaultsKeys.shared.currentUser]) {
     print("UserDefaults reset completed.")
 }


*/

import Foundation

class UserDefaultsKeys {
    static let shared = UserDefaultsKeys()
    private init() { }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    public init(key: KeyPath<UserDefaultsKeys, String>) {
        self.key = UserDefaultsKeys.shared[keyPath: key]
    }
    public var wrappedValue: T? {
        get {
            return UserDefaults.standard.load(object: T.self, fromKey: key)
        }
        set {
            UserDefaults.standard.save(customObject: newValue, inKey: key)
        }
    }
}

extension UserDefaults {

    func save(customObject object: some Encodable, inKey key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        self.set(encoded, forKey: key)
    }

    func load<T: Decodable>(object type: T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func reset(keys: [String], _ completion: @escaping () -> Void) {
        keys.forEach { removeObject(forKey: $0) }
        completion()
    }
}
