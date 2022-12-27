import SwiftUI

struct ContentView: View {

    /*
        @StateObject é um tipo de property wrapper que permite 
        criar uma instância de uma classe de estado que é compartilhada 
        por todas as instâncias de uma visualização.

        Ao usar @StateObject, podemos acessar a instância da classe de estado 
        como uma propriedade normal da visualização. 
        Você também pode usar o $ para criar uma ligação às 
        propriedades publicadas da classe de estado, 
        permitindo que a visualização reaja às mudanças no estado.
    */

    @StateObject var users = User()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            List {
                ForEach(users.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()

                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                /*
                    O onDelete é um modificador que pode ser usado em elementos de lista no SwiftUI 
                    para especificar uma ação a ser executada quando o usuário desliza um item para a 
                    esquerda e toca no botão de exclusão. Ele é geralmente usado em conjunto com a propriedade
                    .editing para permitir que o usuário exclua itens da lista.

                    O onDelete(perform:) é uma variante do modificador onDelete que permite 
                    especificar uma ação a ser executada quando o usuário desliza um item para a 
                    esquerda e toca no botão de exclusão de uma lista. 

                    A diferença entre o onDelete e o onDelete(perform:) é que o onDelete(perform:) 
                    permite que você especifique uma ação externa a ser executada quando o usuário 
                    exclui um item, enquanto o onDelete permite que você coloque o código de 
                    exclusão diretamente na lista. 
                    Isso pode ser útil em situações em que o código de exclusão é 
                    complexo ou se você deseja reutilizar o código em várias listas.
                */
                .onDelete(perform: removeItems)
            }
            .navigationTitle("")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }

    func removeItems(at offsets: IndexSet) {
        users.items.remove(atOffsets: offsets)
    }
}
