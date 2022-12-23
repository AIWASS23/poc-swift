import SwiftUI

struct AddView: View {

    /*
        @ObservedObject é um property wrapper do SwiftUI que permite criar 
        uma dependência de uma classe de estado observável em sua visualização. 

        Para usar @ObservedObject, basta adicioná-lo ao lado de uma propriedade de 
        classe de estado em uma visualização. A classe de estado precisa conformar ao 
        ObservableObject protocol para que o SwiftUI possa observar as 
        propriedades marcadas com @Published e atualizar as visualizações quando essas propriedades mudam.
    */
    @ObservedObject var users: User

    /*
        @Environment é um property wrapper do SwiftUI que permite acessar 
        valores do ambiente de sua aplicação, como preferências de usuário ou 
        informações de gerenciamento de visualização, a partir de qualquer ponto da 
        sua hierarquia de visualização.

        Para usar @Environment, basta adicioná-lo ao lado de uma propriedade em 
        uma visualização. O valor do ambiente é então automaticamente injetado na 
        propriedade quando a visualização é criada.
    */
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add")
            .toolbar {
                Button("Save") {
                    let item = UserItem(name: name, type: type, amount: amount)
                    users.items.append(item)
                    dismiss()
                }
            }
        }
    }
}