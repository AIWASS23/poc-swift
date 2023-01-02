import SwiftUI

/*
    O CheckoutView é uma visualização de checkout que exibe um resumo do pedido de bolo do usuário e 
    um botão "Place Order" para finalizar o pedido. Quando o usuário toca no botão, 
    a função "placeOrder()" é chamada e tenta enviar os detalhes do pedido para um servidor 
    usando uma solicitação HTTP POST. Se a solicitação for bem-sucedida, um alerta é exibido 
    na tela para agradecer o usuário pelo pedido e informá-lo de que o pedido está a caminho.

    A visualização também inclui uma imagem, que é carregada de forma assíncrona usando o AsyncImage. 
    O AsyncImage exibe uma "placeholder" enquanto a imagem está sendo carregada, no caso um ProgressView.

*/

struct CheckoutView: View {
    @ObservedObject var order: Order

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack {

                /*
                    O AsyncImage é uma classe personalizada em SwiftUI que permite carregar 
                    imagens de forma assíncrona em uma visualização. 
                    Ele é útil quando você precisa exibir imagens em sua interface do usuário, 
                    mas não quer bloquear a interface do usuário enquanto as imagens são carregadas.

                    A sintaxe para usar o AsyncImage é:

                    AsyncImage(
                        url: URL, 
                        scale: CGFloat, 
                        placeholder: ViewBuilder, 
                        image: (Image) -> View) -> some View

                    Onde:

                    url é a URL da imagem que deve ser carregada.

                    scale é o fator de escala da imagem.

                    placeholder é uma visualização que deve ser exibida enquanto a imagem está sendo carregada.

                    image é uma closure que recebe a imagem carregada como entrada e retorna uma visualização para exibi-la.

                    EXEMPLO

                    AsyncImage(
                        url: URL(string: "https://example.com/image.jpg")!, 
                        scale: 2, placeholder: { ProgressView()}, 
                        image: { 
                            image in image
                                .resizable()
                                .scaledToFit()
                        }
                    )

                    Isso exibiria um ProgressView enquanto a imagem é carregada, 
                    e exibiria a imagem com um fator de escala de 2 assim que estiver disponível. 
                    A imagem também seria redimensionável e escalada para caber na visualização.

                */
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }

    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed.")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
