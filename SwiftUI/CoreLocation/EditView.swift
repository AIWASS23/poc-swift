import SwiftUI

/*
    O EditView exibe um formulário para editar os detalhes de um lugar. A visualização inclui um 
    campo de texto para o nome do lugar, um campo de texto para a descrição do lugar e uma seção 
    para exibir lugares próximos. Quando o usuário toca no botão "Salvar", os detalhes do lugar 
    são atualizados e a visualização é fechada.

    A visualização também faz uma solicitação à Wikipedia para obter uma lista de lugares próximos 
    ao lugar atualmente sendo editado e exibe os resultados na seção "Lugares próximos". 
    O estado da solicitação é armazenado em uma propriedade de estado chamada loadingState, 
    que pode ter um dos três valores possíveis: .loading, .loaded ou .failed. Se a solicitação estiver 
    sendo carregada, a seção exibirá um indicador de atividade; se a solicitação falhar, a seção exibirá 
    uma mensagem de erro; se a solicitação for bem-sucedida, a seção exibirá os resultados.
*/

struct EditView: View {

    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void

    @State private var name: String
    @State private var description: String

    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }

                Section("Nearby…") {
                    switch loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description

                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }

    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}