import SwiftUI

/*
    O ContentView é um formulário de pedido de bolo que inclui opções para selecionar 
    o tipo de bolo, definir a quantidade de bolos e habilitar solicitações especiais. 
    Se as solicitações especiais estiverem habilitadas, o usuário poderá ativar opções 
    adicionais para cobertura extra e confeitos adicionais.

    O formulário também inclui um link de navegação para outra visualização chamada "AddressView", 
    que deve exibir os detalhes de entrega do pedido.

    A visualização é mostrada dentro de um NavigationView, o que significa que ela será exibida 
    em uma navegação hierárquica em que o usuário poderá navegar para outras visualizações 
    usando o botão "Voltar". O título da visualização é "Cupcake Corner".

    Há também uma estrutura "ContentView_Previews" que permite visualizar a visualização 
    usando um preview de visualização no Xcode.
*/

struct ContentView: View {
    @StateObject var order = Order()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }

                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())

                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }

                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
