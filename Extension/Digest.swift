import CryptoKit

/*

 A extensão para Digest no exemplo fornece uma propriedade hexString, que retorna uma representação
 em formato hexadecimal do resumo criptográfico (hash).

 import CryptoKit

 // Criando um hash SHA-256 de uma string
 let data = "Exemplo de texto para hash".data(using: .utf8)!
 let hashed = SHA256.hash(data: data)

 // Usando a extensão para obter a representação em hexadecimal
 let hexString = hashed.hexString

 print(hexString)


*/

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Digest {

    var hexString: String {
        var result = ""
        for byte in makeIterator() {
            result += String(format: "%02X", byte)
        }
        return result
    }
}