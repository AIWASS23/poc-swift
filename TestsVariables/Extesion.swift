//
//  Extension.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

/* 
    Cria uma nova instância e altera o valor da chave fornecida.
    - Parâmetros:
    - Key: O caminho da chave para a propriedade que você deseja modificar. Use ponto para separar níveis e [] para índices.
    - Exemplos: "id", "name.firstName", "children[2].name.firstName"
    - Valor: O novo valor para a chave fornecida.
    - Return: Uma nova instância com propriedade modificada
*/

/* 
    Às vezes, precisamos modificar uma instância em testes, mas não queremos alterar as propriedades "let" para "var" ou "private" para "internal" apenas para fins de teste.
    Essa extensão usa JSONSerialization para modificar qualquer propriedade em instâncias Codable. 
*/

import Foundation

extension Decodable where Self: Encodable {

    func modifying<T>(_ key: String, to value: T) throws -> Self {
        let originalData = try JSONEncoder().encode(self)
        var object = try JSONSerialization.jsonObject(with: originalData, options: [])

        let keyComponents = keyComponents(from: key)
        object = modify(object, keyComponents: keyComponents, value: value)

        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Self.self, from: data)
    }

    private func modify<T>(_ object: Any, keyComponents: [KeyComponent], value: T) -> Any {
        var keyComponents = keyComponents
        while !keyComponents.isEmpty {
            let keyComponent = keyComponents.removeFirst()
            if var array = object as? [Any], case .index(let index) = keyComponent, index < array.count {
                if keyComponents.isEmpty {
                    array[index] = value
                } else {
                    var nextObject = array[index]
                    nextObject = modify(nextObject, keyComponents: keyComponents, value: value)
                    array[index] = nextObject
                }
                return array
            } else if var dictionary = object as? [String: Any], case .key(let key) = keyComponent {
                if keyComponents.isEmpty {
                    dictionary[key] = value
                } else if var nextObject = dictionary[key] {
                    nextObject = modify(nextObject, keyComponents: keyComponents, value: value)
                    dictionary[key] = nextObject
                }
                return dictionary
            }
        }
        return object
    }

    private func keyComponents(from key: String) -> [KeyComponent] {
        let indexSearch = /(.+)\[(\d+)\]/
        return key.components(separatedBy: ".").flatMap { keyComponent in
            if let result = try? indexSearch.wholeMatch(in: keyComponent), let index = Int(result.2) {
                return [KeyComponent.key(String(result.1)), .index(index)]
            }
            return [.key(keyComponent)]
        }
    }
}

private enum KeyComponent {
    case key(String)
    case index(Int)
}