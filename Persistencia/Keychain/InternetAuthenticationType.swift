import Foundation

public enum InternetAuthenticationType: RawRepresentable {
    case ntlm, msn, dpa, rpa, httpBasic, httpDigest, htmlForm, `default`

    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAuthenticationTypeNTLM):
            self = .ntlm
        case String(kSecAttrAuthenticationTypeMSN):
            self = .msn
        case String(kSecAttrAuthenticationTypeDPA):
            self = .dpa
        case String(kSecAttrAuthenticationTypeRPA):
            self = .rpa
        case String(kSecAttrAuthenticationTypeHTTPBasic):
            self = .httpBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
            self = .httpDigest
        case String(kSecAttrAuthenticationTypeHTMLForm):
            self = .htmlForm
        case String(kSecAttrAuthenticationTypeDefault):
            self = .default
        default:
            self = .default
        }
    }

    public var rawValue: String {
        switch self {
        case .ntlm:
            return String(kSecAttrAuthenticationTypeNTLM)
        case .msn:
            return String(kSecAttrAuthenticationTypeMSN)
        case .dpa:
            return String(kSecAttrAuthenticationTypeDPA)
        case .rpa:
            return String(kSecAttrAuthenticationTypeRPA)
        case .httpBasic:
            return String(kSecAttrAuthenticationTypeHTTPBasic)
        case .httpDigest:
            return String(kSecAttrAuthenticationTypeHTTPDigest)
        case .htmlForm:
            return String(kSecAttrAuthenticationTypeHTMLForm)
        case .default:
            return String(kSecAttrAuthenticationTypeDefault)
        }
    }
}

/*
 O InternetAuthenticationType mapeia os tipos de autenticação usados na chave kSecAttrAuthenticationType do Keychain Services no iOS.

 O InternetAuthenticationType é uma enumeração que implementa o protocolo RawRepresentable, permitindo que os casos do enum sejam representados como valores brutos do tipo String, que é o tipo esperado pela chave kSecAttrAuthenticationType do Keychain Services.

 Os casos do enum representam os diferentes tipos de autenticação disponíveis, como NTLM, MSN, DPA, RPA, HTTP Basic, HTTP Digest, HTML Form e Default. A função init?(rawValue:) permite a conversão de uma String bruta em um caso do enum correspondente, enquanto a propriedade rawValue retorna a String bruta associada a um caso específico do enum.

 Essa implementação pode ser útil para definir e manipular os tipos de autenticação quando se trabalha com o Keychain Services no iOS, por exemplo, ao criar, recuperar ou atualizar senhas e informações de autenticação seguras para aplicativos iOS.
*/
