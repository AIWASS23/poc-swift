import SwiftUI

struct ResortView: View {
    let resort: Resort

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize

    @EnvironmentObject var favorites: Favorites

    @State private var selectedFacility: Facility?
    @State private var showingFacility = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)

                /*
                    Em SwiftUI, o inicializador Image(decorative:) é usado para criar uma exibição de 
                    imagem decorativa. Uma imagem decorativa é uma imagem que é usada como um elemento de 
                    design e não fornece informações significativas para o usuário. Ela pode ser usada, 
                    por exemplo, como um elemento de fundo ou como um ícone de placeholder. Sintaxe:

                    Image(decorative: "imageName"); onde "imageName" é o nome da imagem no seu projeto.

                    Uma imagem decorativa é diferente de uma imagem com conteúdo, que fornece informações 
                    significativas para o usuário, como uma foto de perfil ou uma imagem de produto. Uma 
                    imagem com conteúdo é criada usando o inicializador Image(systemName:) ou Image(uiImage:)
                    É importante notar que o uso de imagens decorativas não é acessível para pessoas com 
                    deficiência visual, já que essas imagens não fornecem nenhuma informação útil.
                */
                    .resizable()
                    .scaledToFit()

                HStack {
                    if sizeClass == .compact && typeSize > .large {

                        /*
                            Em SwiftUI, UserInterfaceSizeClass.compact é uma classe que pode ser usada para 
                            controlar como os elementos de layout são exibidos em dispositivos com 
                            diferentes tamanhos de tela. Ele representa a classe de tamanho "compacto" 
                            de uma interface do usuário, que geralmente é usada em dispositivos menores, 
                            como iPhones. Para usar essa classe, você pode usar o método 
                            .environment(\.horizontalSizeClass) ou .environment(\.verticalSizeClass) 
                            para especificar que os elementos dentro do seu layout devem ser exibidos 
                            de forma compacta quando a tela estiver em uma classe de tamanho compacto.

                            Em SwiftUI, DynamicTypeSize.large é uma classe que pode ser usada para 
                            controlar o tamanho do texto exibido na interface do usuário. Ela é usada em 
                            conjunto com o método .dynamicTypeSize(size:) para especificar que o texto 
                            deve ser exibido em um tamanho grande, independentemente das preferências de 
                            tamanho de texto do usuário. Quando você adiciona essa classe ao elemento de 
                            texto, ele irá exibir o texto no tamanho grande, independentemente das 
                            preferências de tamanho de texto do usuário. Isso pode ser útil para destacar 
                            informações importantes na interface do usuário.

                            Além do DynamicTypeSize.large existem outras opções como .title, .body, .caption etc.

                            Obs: é importante notar que o uso de um tamanho de texto fixo pode não ser 
                            acessível para todos os usuários, então é recomendado usar .dynamicTypeSize() 
                            sem especificar o tamanho para deixar a escolha do tamanho do texto para o 
                            usuário.
                        */

                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Group {
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }

                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
        .environmentObject(Favorites())
    }
}
