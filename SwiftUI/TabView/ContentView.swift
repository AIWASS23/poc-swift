import SwiftUI

/*
    O ContentView representa a tela principal da aplicação. Essa tela é composta por uma TabView, 
    que contém quatro guias: "Everyone", "Contacted", "Uncontacted" e "Me". Cada guia é exibida através 
    de uma instância da struct ProspectsView, com um filtro específico, ou MeView. A struct ProspectsView é 
    uma visualização que exibe uma lista de prospectos. O estado do prospectos é gerenciado através de um 
    objeto @StateObject chamado prospects, que é passado para as visualizações como um objeto ambiente.
*/

struct ContentView: View {
    @StateObject var prospects = Prospects()

    var body: some View {
        TabView {

            /*
                TabView é um componente de interface do usuário fornecido pela biblioteca SwiftUI. 
                Ele permite exibir várias visualizações em guias separadas, com uma guia selecionada ao 
                mesmo tempo. Cada guia é representada por um TabItem, que pode conter um rótulo e uma 
                imagem. O rótulo é exibido como texto e a imagem é exibida como um ícone. O TabView é 
                inicializado com um conjunto de guias e cada guia é um View. O usuário pode alternar entre 
                as guias tocando ou clicando nelas.
            */

            ProspectsView(filter: .none)
                .tabItem {

                    /*
                        TabItem é um componente visual do SwiftUI que é usado para criar guias na interface 
                        do usuário. Ele é usado junto com o TabView para fornecer uma navegação baseada em 
                        guias para o usuário. Cada guia é representada por um TabItem e é usada para 
                        alternar entre diferentes exibições de conteúdo. Exemplo:

                        TabView {
                            TabItem(title: "First Tab") {
                                Text("This is the content of the first tab")
                            }
                            TabItem(title: "Second Tab") {
                                Text("This is the content of the second tab")
                            }
                        }

                        A guia atualmente selecionada é exibida na tela e o usuário pode alternar 
                        entre as guias clicando nelas.
                    */

                    Label("Everyone", systemImage: "person.3")
                }

            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }

            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }

            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)

        /*
            O environmentObject é uma propriedade do SwiftUI que permite passar dados através da 
            hierarquia de views de uma aplicação. Ele é útil quando você tem dados que precisam ser 
            compartilhados entre várias views e subviews, mas não deseja passá-los manualmente através de 
            várias camadas de modificadores.

            Para usar o environmentObject, você precisa primeiro criar uma classe que representa seus dados 
            e marcá-la com ObservableObject. Em seguida, você precisa adicionar uma instância desse objeto 
            ao ambiente de sua aplicação, geralmente dentro do corpo do seu ContentView.
        */
    }
}