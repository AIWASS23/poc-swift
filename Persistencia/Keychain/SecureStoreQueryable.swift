import Foundation

public protocol SecureStoreQueryable {
    var query: [String: Any] { get }
}

public struct GenericPasswordQueryable {
    let service: String
    let accessGroup: String?

    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

extension GenericPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        // Access group if target environment is not simulator
#if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
#endif
        return query
    }
}

public struct InternetPasswordQueryable {
    let server: String
    let port: Int
    let path: String
    let securityDomain: String
    let internetProtocol: InternetProtocol
    let internetAuthenticationType: InternetAuthenticationType
}

extension InternetPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassInternetPassword
        query[String(kSecAttrPort)] = port
        query[String(kSecAttrServer)] = server
        query[String(kSecAttrSecurityDomain)] = securityDomain
        query[String(kSecAttrPath)] = path
        query[String(kSecAttrProtocol)] = internetProtocol.rawValue
        query[String(kSecAttrAuthenticationType)] = internetAuthenticationType.rawValue
        return query
    }
}

/*
 
 GenericPasswordQueryable: É uma estrutura que implementa o protocolo SecureStoreQueryable. Ela representa uma consulta para acessar senhas genéricas (generic passwords) no serviço de chaveiro. Ela possui duas propriedades: service, que é o nome do serviço associado à senha, e accessGroup, que é um identificador de grupo de acesso opcional para compartilhar chaves entre aplicativos relacionados. A estrutura tem um método computado query que retorna um dicionário de consulta que pode ser usado para buscar senhas genéricas no serviço de chaveiro.

 InternetPasswordQueryable: É outra estrutura que também implementa o protocolo SecureStoreQueryable. Ela representa uma consulta para acessar senhas de internet (internet passwords) no serviço de chaveiro. Ela possui várias propriedades, incluindo server, port, path, securityDomain, internetProtocol e internetAuthenticationType, que representam os detalhes do servidor e protocolo para o qual a senha de internet está associada. A estrutura tem um método computado query que retorna um dicionário de consulta que pode ser usado para buscar senhas de internet no serviço de chaveiro.

*/
