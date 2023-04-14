import Foundation

public enum InternetProtocol: RawRepresentable {
    case ftp, ftpAccount, http, irc, nntp, pop3, smtp, socks, imap, ldap, appleTalk, afp, telnet, ssh, ftps, https, httpProxy, httpsProxy, ftpProxy, smb, rtsp, rtspProxy, daap, eppc, ipp, nntps, ldaps, telnetS, imaps, ircs, pop3S

    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrProtocolFTP):
            self = .ftp
        case String(kSecAttrProtocolFTPAccount):
            self = .ftpAccount
        case String(kSecAttrProtocolHTTP):
            self = .http
        case String(kSecAttrProtocolIRC):
            self = .irc
        case String(kSecAttrProtocolNNTP):
            self = .nntp
        case String(kSecAttrProtocolPOP3):
            self = .pop3
        case String(kSecAttrProtocolSMTP):
            self = .smtp
        case String(kSecAttrProtocolSOCKS):
            self = .socks
        case String(kSecAttrProtocolIMAP):
            self = .imap
        case String(kSecAttrProtocolLDAP):
            self = .ldap
        case String(kSecAttrProtocolAppleTalk):
            self = .appleTalk
        case String(kSecAttrProtocolAFP):
            self = .afp
        case String(kSecAttrProtocolTelnet):
            self = .telnet
        case String(kSecAttrProtocolSSH):
            self = .ssh
        case String(kSecAttrProtocolFTPS):
            self = .ftps
        case String(kSecAttrProtocolHTTPS):
            self = .https
        case String(kSecAttrProtocolHTTPProxy):
            self = .httpProxy
        case String(kSecAttrProtocolHTTPSProxy):
            self = .httpsProxy
        case String(kSecAttrProtocolFTPProxy):
            self = .ftpProxy
        case String(kSecAttrProtocolSMB):
            self = .smb
        case String(kSecAttrProtocolRTSP):
            self = .rtsp
        case String(kSecAttrProtocolRTSPProxy):
            self = .rtspProxy
        case String(kSecAttrProtocolDAAP):
            self = .daap
        case String(kSecAttrProtocolEPPC):
            self = .eppc
        case String(kSecAttrProtocolIPP):
            self = .ipp
        case String(kSecAttrProtocolNNTPS):
            self = .nntps
        case String(kSecAttrProtocolLDAPS):
            self = .ldaps
        case String(kSecAttrProtocolTelnetS):
            self = .telnetS
        case String(kSecAttrProtocolIMAPS):
            self = .imaps
        case String(kSecAttrProtocolIRCS):
            self = .ircs
        case String(kSecAttrProtocolPOP3S):
            self = .pop3S
        default:
            self = .http
        }
    }

    public var rawValue: String {
        switch self {
        case .ftp:
            return String(kSecAttrProtocolFTP)
        case .ftpAccount:
            return String(kSecAttrProtocolFTPAccount)
        case .http:
            return String(kSecAttrProtocolHTTP)
        case .irc:
            return String(kSecAttrProtocolIRC)
        case .nntp:
            return String(kSecAttrProtocolNNTP)
        case .pop3:
            return String(kSecAttrProtocolPOP3)
        case .smtp:
            return String(kSecAttrProtocolSMTP)
        case .socks:
            return String(kSecAttrProtocolSOCKS)
        case .imap:
            return String(kSecAttrProtocolIMAP)
        case .ldap:
            return String(kSecAttrProtocolLDAP)
        case .appleTalk:
            return String(kSecAttrProtocolAppleTalk)
        case .afp:
            return String(kSecAttrProtocolAFP)
        case .telnet:
            return String(kSecAttrProtocolTelnet)
        case .ssh:
            return String(kSecAttrProtocolSSH)
        case .ftps:
            return String(kSecAttrProtocolFTPS)
        case .https:
            return String(kSecAttrProtocolHTTPS)
        case .httpProxy:
            return String(kSecAttrProtocolHTTPProxy)
        case .httpsProxy:
            return String(kSecAttrProtocolHTTPSProxy)
        case .ftpProxy:
            return String(kSecAttrProtocolFTPProxy)
        case .smb:
            return String(kSecAttrProtocolSMB)
        case .rtsp:
            return String(kSecAttrProtocolRTSP)
        case .rtspProxy:
            return String(kSecAttrProtocolRTSPProxy)
        case .daap:
            return String(kSecAttrProtocolDAAP)
        case .eppc:
            return String(kSecAttrProtocolEPPC)
        case .ipp:
            return String(kSecAttrProtocolIPP)
        case .nntps:
            return String(kSecAttrProtocolNNTPS)
        case .ldaps:
            return String(kSecAttrProtocolLDAPS)
        case .telnetS:
            return String(kSecAttrProtocolTelnetS)
        case .imaps:
            return String(kSecAttrProtocolIMAPS)
        case .ircs:
            return String(kSecAttrProtocolIRCS)
        case .pop3S:
            return String(kSecAttrProtocolPOP3S)
        }
    }
}

/*
 O InternetProtocol representa os protocolos de internet usados em um aplicativo iOS/macOS. Ele implementa o protocolo RawRepresentable, permitindo que os casos do enum sejam representados por valores brutos (no caso, strings).

 Os casos do enum representam diferentes protocolos de internet, como FTP, HTTP, IRC, SMTP, HTTPS, entre outros. O enum possui dois métodos, init?(rawValue: String) e rawValue, que são usados para converter entre os casos do enum e suas representações em strings, usando constantes definidas no framework Foundation do iOS/macOS, como kSecAttrProtocolFTP, kSecAttrProtocolHTTP, etc.

 O método init?(rawValue: String) é um inicializador opcional que recebe uma string como entrada e tenta mapeá-la para um dos casos do enum, retornando nil caso a string não corresponda a nenhum caso. O método rawValue retorna a representação em string do valor bruto do enum.

 No geral, esse código permite representar e manipular os protocolos de internet de forma mais legível e segura em um aplicativo iOS/macOS que utiliza o framework Foundation.
*/
