import SwiftUI

/*
    O AndressView é uma visualização de endereço que permite ao usuário inserir seu nome, 
    endereço de rua, cidade e código postal. Ela também inclui um link de navegação para 
    outra visualização chamada "CheckoutView", que deve exibir um resumo do pedido de bolo do usuário.

    A visualização é mostrada dentro de um NavigationView, o que significa que ela será 
    exibida em uma navegação hierárquica em que o usuário poderá navegar para outras 
    visualizações usando o botão "Voltar". O título da visualização é "Delivery details".

    O link de navegação para a visualização de checkout só está habilitado se o 
    endereço for válido, o que é determinado pelo valor da propriedade "hasValidAddress" do objeto "order".
*/

struct AddressView: View {
    @ObservedObject var order: Order

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }

            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }

            /*
                O método disabled(_:) é um método de modificação de visualização em SwiftUI 
                que permite desabilitar uma visualização. Quando uma visualização é desabilitada, 
                ela não pode ser interagida pelo usuário e aparece com uma aparência diferente na 
                interface do usuário para indicar que está desabilitada.

                A sintaxe para usar o disabled(_:) é:

                .disabled(Bool)

                EXEMPLO
                Button("Submit") {
                    // fazer algo quando o botão é tocado
                }
                .disabled(isButtonDisabled)

                Isso desabilitaria o botão se a variável "isButtonDisabled" 
                for verdadeira e o habilitaria se for falsa.

                Posso usar o disabled(_:) em um link de navegação para desabilitar a 
                navegação para outra visualização:

                NavigationLink {
                    Text("Next")
                } label: {
                    Text("Next")
                }
                .disabled(isNextButtonDisabled)

                Isso desabilitaria o link de navegação se a variável "isNextButtonDisabled" 
                for verdadeira e o habilitaria se for falsa.
            */
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(order: Order())
        }
    }
}
