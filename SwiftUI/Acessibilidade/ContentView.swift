import SwiftUI

/*
    Este script define três estruturas: "GroupChildrenContentView", "ReadingValuesContentView" e "ContentView".

    A struct "GroupChildrenContentView" é uma visualização simples que contém um VStack (pilha vertical) 
    com dois textos, um dizendo "Your score is" e outro mostrando "1000" com um tamanho de fonte diferente. 
    Há também uma propriedade "accessibilityElement" e "accessibilityLabel" adicionado para facilitar o 
    acesso a leitor de tela.

    A struct "ReadingValuesContentView" é uma visualização que exibe um valor inicial de 10 e dois botões 
    Increment e Decrement que permitem ao usuário incrementar ou decrementar esse valor. Há propriedades
    accessibilityElement, accessibilityLabel, accessibilityValue e accessibilityAdjustableAction são 
    adicionadas para facilitar o acesso a leitor de tela.

    A struct "ContentView" exibe uma imagem aleatória a partir de um array de imagens e rótulos, e permite 
    ao usuário tocar na imagem para selecionar uma nova imagem aleatória. Há propriedades accessibilityLabel, 
    accessibilityAddTraits e accessibilityRemoveTraits adicionadas para facilitar o acesso a leitor de tela.
*/

struct GroupChildrenContentView: View {
    var body: some View {
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
        .accessibilityElement(children: .ignore)

        /*
            A propriedade accessibilityElement do SwiftUI é usada para especificar como uma visualização 
            deve ser tratada pelo sistema de acessibilidade do iOS. Ele pode ser adicionado a qualquer 
            visualização para fornecer informações sobre como a visualização deve ser lidada pelo sistema 
            de acessibilidade.

            Quando você adiciona accessibilityElement(children: .ignore) na sua visualização, ele diz ao 
            sistema de acessibilidade para ignorar qualquer conteúdo aninhado dentro da visualização e, 
            em vez disso, usar a propriedade accessibilityLabel para identificar a visualização. Exemplo:

            VStack {
                        Text("Your score is")
                        Text("1000")
                            .font(.title)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Your score is 1000")

            Aqui a VStack é usada como um container e não é importante para o sistema de acessibilidade, 
            o conteúdo mais importante é o "Your score is 1000", então a propriedade 
            .accessibilityElement(children: .ignore) diz ao sistema de acessibilidade para ignorar os 
            componentes de dentro da VStack e se concentrar na propriedade 
            .accessibilityLabel("Your score is 1000")

            Ele também pode ser utilizado para especificar como um componente deve reagir a ações de 
            acessibilidade. Por exemplo, se você adicionar .accessibilityElement(children: .combine) em 
            um componente, o sistema de acessibilidade combinará o conteúdo de todos os componentes 
            filhos em uma única entrada no leitor de tela.
        */
        .accessibilityLabel("Your score is 1000")

        /*
            A propriedade accessibilityLabel do SwiftUI é usada para fornecer um rótulo de acessibilidade 
            para uma visualização específica. O rótulo de acessibilidade é o texto que é lido pelo leitor 
            de tela para ajudar os usuários com deficiência a entender o que a visualização representa ou 
            faz. Exemplo:

            Text("Your score is 1000")
                .accessibilityLabel("Your score is 1000")

            Aqui, o texto "Your score is 1000" é mostrado na tela, mas o rótulo de acessibilidade é 
            "Your score is 1000" para que o leitor de tela lê "Your score is 1000" para os usuários com 
            deficiência visual.

            É possível usar accessibilityLabel em conjunto com outras propriedades de acessibilidade para 
            fornecer informações adicionais sobre uma visualização. Por exemplo, você pode usar 
            accessibilityLabel para fornecer um rótulo e accessibilityValue para fornecer um valor 
            atual associado a uma visualização, ou accessibilityHint para fornecer instruções para usuários 
            sobre como interagir com a visualização.
        */
    }
}

struct ReadingValuesContentView: View {
    @State private var value = 10

    var body: some View {
        VStack {
            Text("Value: \(value)")

            Button("Increment") {
                value += 1
            }

            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))

        /*
            A propriedade accessibilityValue do SwiftUI é usada para fornecer um valor atual associado a 
            uma visualização, especialmente para elementos que possuem valores que podem mudar 
            dinamicamente como por exemplo Sliders, Progress Bars, etc. O valor de acessibilidade é um 
            texto que é lido pelo leitor de tela para ajudar os usuários com deficiência a entender o valor 
            atual associado a uma visualização. Exemplo: 

            HStack {
                Text("Volume")
                Slider(value: $volume)
            }
            .accessibilityValue(String(format: "%.0f%%", volume * 100))

            Aqui, existe um Slider para controlar o volume, e o valor atual do volume é mostrado ao lado 
            dele. O valor de acessibilidade é o volume * 100 em porcentagem.

            A propriedade accessibilityValue é usada em conjunto com a propriedade accessibilityLabel para 
            fornecer informações adicionais sobre uma visualização. A accessibilityValue fornece o valor 
            atual enquanto a accessibilityLabel fornece um rótulo descritivo sobre a visualização.
        */
        .accessibilityAdjustableAction { direction in

        /*
            A propriedade accessibilityAdjustableAction do SwiftUI é usada para especificar uma ação 
            personalizada que será chamada quando o usuário ajusta um elemento de interface com o sistema 
            de acessibilidade. Ela é geralmente usada em conjunto com elementos como sliders, steppers e 
            switches que possuem valores que podem ser ajustados dinamicamente.

            A função passada como parâmetro é chamada com um argumento direction que indica se o usuário 
            está solicitando um aumento (incremento) ou uma redução (decremento) no valor. A função pode 
            então atualizar o valor da visualização de acordo. Exemplo:

            HStack {
                Text("Volume")
                Slider(value: $volume)
            }
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    volume += 0.1
                case .decrement:
                    volume -= 0.1
                }
            }

            Aqui, existe um Slider para controlar o volume, e o usuário pode ajustar o volume aumentando ou 
            diminuindo o valor. A função passada na propriedade accessibilityAdjustableAction é chamada com 
            o argumento "direction", e dependendo do valor de "direction" (incremento ou decremento) o valor
             é atualizado.

            Essa propriedade é útil para melhorar a acessibilidade para usuários que utilizam leitor de 
            tela, pois permite que eles ajustem o valor de forma fácil e intuitiva sem precisar de 
            interagir diretamente com o elemento de interface.
        */
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled")
            }
        }
    }
}

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]

    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]

    @State private var selectedPicture = Int.random(in: 0...3)

    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
            .accessibilityLabel(labels[selectedPicture])
            .accessibilityAddTraits(.isButton)

            /*
                A propriedade accessibilityAddTraits do SwiftUI é usada para adicionar traços de 
                acessibilidade a uma visualização específica. Os traços de acessibilidade são rótulos 
                adicionais que o sistema de acessibilidade usa para fornecer informações adicionais sobre 
                como uma visualização deve ser lidada.

                Existem vários traços de acessibilidade pré-definidos no iOS como
                 .button, .link, .header, .image, .playsSound, entre outros. Os traços podem ser adicionados
                ou removidos dinamicamente conforme a necessidade. Exemplo:

                Image(systemName: "play")
                    .accessibility(label: Text("Play"))
                    .accessibility(addTraits: .isButton)

                Aqui, há uma imagem do sistema que representa o botão de reprodução, usando a propriedade 
                accessibilityLabel para dar um rótulo para ele "Play", e usando accessibilityAddTraits para 
                adicionar o traço .isButton. Isso indica para o sistema de acessibilidade que essa imagem 
                representa um botão, e então a interação com ele pode ser feita como se fosse um botão.

                Além disso, essa propriedade pode ser usada para adicionar mais de um traço a uma 
                visualização, por exemplo:

                Image(systemName: "play")
                    .accessibility(label: Text("Play"))
                    .accessibility(addTraits: [.isButton, .playsSound])
                Aqui a imagem é definida como um botão e reproduz som ao ser pressionada.

                Adicionar traços de acessibilidade às suas visualizações pode ajudar a tornar o seu 
                aplicativo mais acessível para usuários com deficiência, facilitando a interação com o 
                aplicativo e tornando a informação mais clara e fácil de entender.
            */
            .accessibilityRemoveTraits(.isImage)

            /*
                A propriedade accessibilityRemoveTraits do SwiftUI é usada para remover traços de 
                acessibilidade de uma visualização específica. Os traços de acessibilidade são rótulos 
                adicionais que o sistema de acessibilidade usa para fornecer informações adicionais sobre 
                como uma visualização deve ser lidada.

                Funciona de maneira semelhante a accessibilityAddTraits, mas ao invés de adicionar traços, 
                remove traços já existentes. Exemplo:

                Image(systemName: "play")
                    .accessibility(label: Text("Play"))
                    .accessibility(addTraits: .isButton)
                    .accessibility(removeTraits: .isButton)

                Aqui, há uma imagem do sistema que representa o botão de reprodução, usando a propriedade 
                accessibilityLabel para dar um rótulo para ele "Play", e usando accessibilityAddTraits 
                para adicionar o traço .isButton. Depois, usando accessibilityRemoveTraits para remover 
                o traço .isButton. Isso indica para o sistema de acessibilidade de que essa imagem não é 
                mais tratada como um botão e suas interações serão diferentes de um botão.

                É importante notar que essa propriedade é usada para remover traços específicos e não para 
                limpar todos os traços existentes. Se você quiser remover todos os traços de uma 
                visualização, você deve criá-la novamente sem traços adicionais.

                Remover traços de acessibilidade é importante quando uma visualização muda dinamicamente e 
                pode ser tratada de maneira diferente em diferentes estados ou cenários, ou quando você 
                deseja mudar a maneira como o sistema de acessibilidade trata uma visualização específica. 
                Isso ajuda a garantir que o sistema de acessibilidade esteja sempre fornecendo informações 
                precisas e atualizadas sobre sua interface do usuário.
            */
    }
}
