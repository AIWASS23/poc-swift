import Foundation
import SwiftUI

/*
// Cria um objeto Loadable
let myLoadableItem = Loadable<String>(value: "Conteúdo carregado com sucesso")

// Define a estrutura LoadableView com blocos de construção para sucesso e falha
LoadableView(myLoadableItem,
    content: { loadedItem in
        Text("Conteúdo: \(loadedItem)")
    },
    failure: { error in
        Text("Falha ao carregar: \(error.localizedDescription)")
    }
)

a estrutura LoadableView facilita a exibição de diferentes visualizações dependendo 
do estado do carregamento de um item, tornando a interface do usuário mais dinâmica e 
adaptável ao contexto de carregamento de dados.
*/

struct LoadableView<Content: View, Failure: View, Item>: View {
    
    let loadable: Loadable<Item>
    let content: (Item) -> Content
    let failure: (Error) -> Failure
    
    init(_ loadable: Loadable<Item>, @ViewBuilder content: @escaping (Item) -> Content, @ViewBuilder failure: @escaping (Error) -> Failure) {
        self.loadable = loadable
        self.content = content
        self.failure = failure
    }
    
    var body: some View {
        if let error = loadable.error {
            failure(error)
        } else {
            content(loadable.valueOrPlaceholder)
                .shimmering(if: loadable.isLoading)
                .disabled(loadable.isLoading)
        }
    }
}
