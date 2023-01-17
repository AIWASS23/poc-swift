import CoreData
import SwiftUI

/*
    A struct FilteredList, que é um tipo genérico que exibe uma lista filtrada de 
    objetos gerenciados do Core Data em uma interface do usuário da biblioteca SwiftUI.

    A struct tem dois tipos genéricos: T e Content. O tipo T é o tipo de objeto gerenciado do Core Data 
    que a lista deve exibir, enquanto o tipo Content é o tipo de vista que será usado para exibir 
    cada item da lista.

    A struct tem uma propriedade chamada fetchRequest, que é um objeto FetchRequest do Core Data 
    usado para recuperar os objetos gerenciados da base de dados, também tem uma 
    propriedade computada chamada singers, que retorna os objetos recuperados pelo fetchRequest.

    A struct tem uma propriedade chamada content, que é um closure (ou bloco) 
    que é chamado para cada item da lista para exibir o item. 
    O tipo do closure é (T) -> Content, o que significa que ele recebe um objeto do tipo T 
    como entrada e retorna uma view do tipo Content.

    A struct tem um inicializador que aceita três parâmetros: 
    um nome de chave de filtro, 
    um valor de filtro e o closure de conteúdo. 
    O inicializador cria o fetchRequest usando um predicado que filtra os objetos 
    com base na chave de filtro e no valor de filtro especificados.

    A struct tem uma propriedade body que exibe a lista de objetos gerenciados usando a 
    biblioteca SwiftUI. A lista é criada a partir da propriedade singers e cada 
    item da lista é exibido usando o closure de conteúdo fornecido.
*/

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    let content: (T) -> Content
    // este é o clousure de content; chamado uma vez para cada item na lista

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String,  content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}