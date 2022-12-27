import Foundation

struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}

/*
    O protocolo Codable do Swift é um protocolo composto que 
    combina os protocolos Encodable e Decodable. 
    Ele é usado para converter objetos para e de representações codificadas, como JSON ou plist.

    Para fazer com que uma struct ou classe seja codificável, 
    basta adotar o protocolo Codable e implementar os métodos necessários. 
    O Swift fornece a sintaxe CodingKeys para mapear as propriedades do seu 
    objeto para os nomes das chaves na representação codificada.

    Exemplo:

    struct Product: Codable {
        var name: String
        var price: Double
        var description: String

        enum CodingKeys: String, CodingKey {
            case name
            case price
            case description
        }
    }

    A struct Product adota o protocolo Codable e define as propriedades name, price e description. 
    Ela também define o enum CodingKeys para mapear as propriedades para os nomes das chaves 
    na representação codificada.

    Para CODIFICAR um objeto Product em uma representação codificada, como JSON, 
    basta usar o seguinte código:

    let product = Product(name: "Produto 1", price: 19.99, description: "Descrição do produto 1")

    let encoder = JSONEncoder()
    if let data = try? encoder.encode(product) {
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
    }

    Para DECODIFICAR uma representação codificada em um objeto Product, 
    basta usar o seguinte código:

    let jsonString = "{\"name\":\"Produto 1\",\"price\":19.99,\"description\":\"Descrição do produto 1\"}"

    if let data = jsonString.data(using: .utf8) {
        let decoder = JSONDecoder()
        if let product = try? decoder.decode(Product.self, from: data) {
            print(product)
        }
    }
*/

/*
    O protocolo Identifiable do Swift é usado para identificar únicamente 
    um tipo em uma coleção. Ele é usado principalmente com o SwiftUI para facilitar o 
    rastreamento de alterações em coleções de visualizações.

    Para adotar o protocolo Identifiable, basta fazer com que o seu tipo tenha 
    uma propriedade id única do tipo Hashable.

    O protocolo Identifiable também pode ser usado com outros tipos de coleções, 
    como dicionários e conjuntos. No entanto, é importante lembrar que o 
    tipo de chave do dicionário ou do conjunto deve ser do 
    tipo Hashable para que o tipo possa adotar o protocolo Identifiable.
*/

/*
    O protocolo Hashable do Swift é um protocolo que define um método de 
    hash único para um tipo. Ele é usado para armazenar e comparar objetos de forma rápida e 
    eficiente em coleções, como dicionários e conjuntos.

    Exemplo:

    struct Product: Hashable {
        
    let name: String
    let price: Double

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(price)
        }

        static func == (lhs: Product, rhs: Product) -> Bool {
            return lhs.name == rhs.name && lhs.price == rhs.price
        }
    }

*/