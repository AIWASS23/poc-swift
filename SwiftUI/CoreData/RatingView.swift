import SwiftUI

/*
    Essa struct define uma visualização de classificação que exibe uma sequência de 
    imagens de estrelas e permite que o usuário classifique um item de 1 a 5 estrelas. 
    A classificação atual é armazenada na propriedade de ligação rating, 
    que pode ser atualizada pelo usuário tocando em uma estrela.

    A struct tem várias propriedades que você pode usar para personalizar 
    a aparência e o comportamento da visualização de classificação. 
    Por exemplo, você pode usar as propriedades offImage e onImage para 
    especificar as imagens a serem usadas para as estrelas desligadas e ligadas, respectivamente. 
    Além disso, você pode usar as propriedades offColor e onColor para especificar as cores a 
    serem usadas para as estrelas desligadas e ligadas.

    A struct também tem uma propriedade label que pode ser usada para exibir um rótulo 
    antes da sequência de estrelas. Por exemplo, você pode usar o rótulo para exibir a palavra 
    "Classificação:" antes da sequência de estrelas.
*/

struct RatingView: View {

    /*
        O tipo @Binding no SwiftUI é um tipo de ligação unidirecional que permite 
        que você passe um valor de uma visualização para outra de forma segura. 
        Ele é semelhante ao tipo @State, mas enquanto o @State é usado para armazenar 
        valores internos a uma visualização, o @Binding é usado para passar valores de 
        uma visualização para outra.

        Por exemplo, imagine que você tem uma visualização que exibe um botão "Curtir" 
        e um rótulo que mostra o número de curtidas. Você pode usar o @Binding para passar 
        o número de curtidas de uma visualização para outra, como no exemplo:

        struct ContentView: View {
            @State private var likes = 0

            var body: some View {
                VStack {
                    Button("Curtir") {
                        self.likes += 1
                    }

                    LikesView(likes: $likes)
                }
            }
        }

        struct LikesView: View {
            @Binding var likes: Int

            var body: some View {
                Text("\(likes) curtidas")
            }
        }

        Nesse exemplo, a visualização ContentView tem um estado interno chamado 
        likes que é atualizado quando o usuário pressiona o botão "Curtir". 
        A visualização LikesView exibe o número de curtidas usando um @Binding 
        para acessar o valor de likes. Dessa forma, quando o usuário pressiona o 
        botão "Curtir" e o valor de likes é atualizado na visualização ContentView, 
        a visualização LikesView é atualizada automaticamente para exibir o novo número de curtidas.
    */
    @Binding var rating: Int

    var label = ""
    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow

    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }

    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}