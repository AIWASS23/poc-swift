import SwiftUI

/*
    Essa extensão cria um método chamado "phoneOnlyNavigationView" que é adicionado a todas as instâncias 
    da estrutura "View" no seu aplicativo. Ele verifica se o dispositivo atual tem o tipo de interface do 
    usuário "telefone" usando a propriedade "UIDevice.current.userInterfaceIdiom" e, se for verdadeiro, 
    aplica o estilo de navegação "stack" à visualização atual. Caso contrário, a visualização atual é 
    retornada sem qualquer alteração. Esse método pode ser usado para exibir diferentes estilos de 
    navegação de acordo com o tipo de dispositivo.
*/

extension View {

    /*
        @ViewBuilder é um atributo do SwiftUI que indica que a função ou método que o usa retorna uma vista 
        (View) ou uma coleção de vistas. Ele ajuda o compilador a entender como construir a estrutura de 
        visualização a partir dos elementos retornados. Quando usado em conjunto com um corpo de função 
        que contém várias declarações, o compilador entende que essas declarações devem ser combinadas 
        para formar uma única visualização. Isso é útil para construir vistas condicionais, onde algumas 
        partes da visualização podem ser exibidas ou ocultas com base em condições específicas.
    */

    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {

            /*
                "UIDevice" é uma classe do iOS (iOS SDK) que fornece informações sobre o dispositivo atual, 
                como o tipo de dispositivo, o nome, a versão do sistema operacional e outras configurações.
                A propriedade "UIDevice.current.userInterfaceIdiom" é usada para determinar se o 
                dispositivo atual é um iPhone, iPad ou outro tipo de dispositivo. O valor retornado pode 
                ser .phone (iPhone), .pad (iPad), .tv (Apple TV), .carPlay (CarPlay), 
                .mac (Mac) ou .unspecified. https://developer.apple.com/documentation/uikit/uidevice/
            */

            self.navigationViewStyle(.stack)

            /*
                .navigationViewStyle é uma propriedade da estrutura "NavigationView" do SwiftUI que 
                determina o estilo de navegação a ser usado em seu aplicativo. Ele pode ser usado para 
                alterar o estilo de navegação de uma visualização específica. Os valores possíveis são:

                .automatic: o estilo de navegação é determinado automaticamente pelo sistema, com base no 
                dispositivo e no contexto de navegação.

                .stack: o estilo de navegação empilhado, onde as visualizações são empilhadas umas sobre as 
                outras e o usuário pode voltar para visualizações anteriores deslizando para a esquerda.

                .column: o estilo de navegação de coluna dupla, onde a lista de visualizações é exibida ao 
                lado da visualização selecionada. Este estilo é usado principalmente em iPads.
            */

        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")

    @StateObject var favorites = Favorites()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }

                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")

            /*
                .searchable é um método do SwiftUI que adiciona uma barra de pesquisa à sua visualização. 
                Ele é usado para filtrar dados de uma lista ou coleção de acordo com o texto digitado pelo 
                usuário. O método tem dois parâmetros:

                text: um valor @Binding do tipo String que contém o texto digitado na barra de pesquisa.

                prompt: um valor String que é exibido como um placeholder na barra de pesquisa quando ela 
                está vazia.
            */

            WelcomeView()
        }
        .environmentObject(favorites)
    }

    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
