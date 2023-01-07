/*
    a aplicação SwiftUI exibe um mapa com anotações e permite ao usuário adicionar, 
    editar e excluir locais. A aplicação também parece ter uma funcionalidade de 
    autenticação que bloqueia o acesso a essas funcionalidades até que o usuário faça login.

    Aqui está um resumo geral de como o código funciona:

    A struct ContentView é a visualização principal da aplicação, que é exibida na tela do usuário.

    A visualização exibe um mapa usando o componente Map da SwiftUI, 
    com uma região de coordenadas e uma lista de anotações fornecidas por um objeto ViewModel. 
    As anotações são exibidas como imagens de estrelas vermelhas em círculos brancos.

    Se o usuário tocar em uma anotação, ela é selecionada e uma nova visualização é exibida em uma 
    sheet contendo um formulário para editar o local selecionado.

    O usuário também pode tocar no botão "plus" para adicionar um novo local ao mapa.

    Se a propriedade isUnlocked do ViewModel for false, a visualização exibe um botão 
    "Unlock Places" que, quando tocado, chama o método authenticate() do ViewModel. 
    Isso é uma funcionalidade de autenticação que desbloqueia o acesso às funcionalidades 
    de adição, edição e exclusão de locais.
*/

import MapKit

/*
    MapKit é um framework do iOS que lhe permite adicionar mapas interativos a suas aplicações iOS. 
    Ele fornece uma interface de programação de aplicativos (API) para integrar mapas em seu aplicativo, 
    exibir locais e marcadores em um mapa, adicionar sobreposições e muito mais.

    Aqui estão alguns recursos úteis para ajudá-lo a começar a trabalhar com o MapKit:

    Documentação do MapKit: https://developer.apple.com/documentation/mapkit
    Tutorial do MapKit: https://www.raywenderlich.com/567-mapkit-tutorial-getting-started
*/

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in

                /*
                    Esse componente exibe um mapa interativo em sua aplicação SwiftUI e 
                    permite adicionar anotações e sobreposições ao mapa.
                    O componente Map é exibido com uma região de coordenadas dada pela propriedade 
                    $viewModel.mapRegion e uma lista de anotações fornecida pela propriedade 
                    viewModel.locations. Cada anotação é criada usando o componente MapAnnotation, 
                    que é inicializado com as coordenadas do local.

                    O componente Map tem várias propriedades que você pode usar para personalizar 
                    sua aparência e comportamento, como colorScheme, showsUserLocation e showsScale.
                    Mais informações: https://developer.apple.com/documentation/swiftui/map
                */
                    MapAnnotation(coordinate: location.coordinate) {

                        /*
                            O componente MapAnnotation da SwiftUI é usado para adicionar anotações a 
                            um mapa exibido pelo componente Map. Ele é inicializado com as coordenadas 
                            do local a ser marcado no mapa e pode conter qualquer conteúdo SwiftUI que 
                            você deseje exibir para o usuário. O componente MapAnnotation também tem 
                            várias propriedades que você pode usar para personalizar a anotação, como title e subtitle.
                            Mais informações: https://developer.apple.com/documentation/swiftui/mapannotation
                        */

                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())

                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()

                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)

                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}
