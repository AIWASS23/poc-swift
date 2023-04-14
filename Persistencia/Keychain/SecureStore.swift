import Foundation
import Security

public struct SecureStore {
    let secureStoreQueryable: SecureStoreQueryable

    public init(secureStoreQueryable: SecureStoreQueryable) {
        self.secureStoreQueryable = secureStoreQueryable
    }

    public func setValue(_ value: String, for userAccount: String) throws {
        guard let encodedPassword = value.data(using: .utf8) else {
            throw SecureStoreError.string2DataConversionError
        }

        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword

            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }

    public func getValue(for userAccount: String) throws -> String? {
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8)
            else {
                throw SecureStoreError.data2StringConversionError
            }
            return password
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

    public func removeValue(for userAccount: String) throws {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    public func removeAllValues() throws {
        let query = secureStoreQueryable.query

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    private func error(from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}

/*
 SecureStore é usada para acessar a Keychain do sistema iOS ou macOS e realizar operações de armazenamento seguro de informações sensíveis, como senhas, chaves de acesso, tokens de autenticação, etc.

 O SecureStore possui os seguintes métodos públicos:

 init(secureStoreQueryable:): Um inicializador que recebe um objeto SecureStoreQueryable como parâmetro, que é usado para configurar a consulta à Keychain.

 setValue(_:for:): Um método que permite armazenar um valor como uma string na Keychain, associando-o a uma conta de usuário específica.

 getValue(for:): Um método que permite recuperar o valor armazenado na Keychain associado a uma conta de usuário específica como uma string.

 removeValue(for:): Um método que permite remover um valor armazenado na Keychain associado a uma conta de usuário específica.

 removeAllValues(): Um método que permite remover todos os valores armazenados na Keychain.
 
 Esses métodos utilizam a API de segurança do sistema operacional iOS ou macOS (Security.framework) para interagir com a Keychain e realizar operações de leitura, gravação e remoção de dados armazenados de forma segura. O código também trata erros específicos retornados pela API de segurança e os converte em um tipo de erro personalizado SecureStoreError, que é definido em outro lugar do código não mostrado aqui.
*/
