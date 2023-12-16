import Foundation

/*
Recupera com segurança um elemento no índice especificado, se existir.
Verifica se a coleção contém o índice especificado.
Se o índice estiver dentro do intervalo válido de índices para a coleção,
retorna o elemento nesse índice. Caso contrário, retorna `nil`.
*/

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}