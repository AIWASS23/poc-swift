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
