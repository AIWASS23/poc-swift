import SwiftUI

/*
    CardView é uma visualização personalizada de um cartão. Ele exibe um cartão com um pergunta (prompt) 
    e uma resposta (answer) e permite que o usuário interaja com ele, fazendo gestos de arrastar e tocar. 
    A struct "CardView" tem as seguintes características:

    Aceita um objeto "card" que contém a pergunta e a resposta do cartão. A propriedade 
    "removal" que é uma closure opcional que é chamada quando o cartão é arrastado para fora da tela. 
    O "UINotificationFeedbackGenerator" para gerar feedbacks de notificação. As propriedades 
    "differentiateWithoutColor" e "voiceOverEnabled" do ambiente para adaptar a interface de acordo com as 
    configurações de acessibilidade do dispositivo. A propriedade "isShowingAnswer" que indica se a 
    resposta está sendo exibida ou não. O CardView usa o gesto de arrastar para permitir que o usuário 
    remova o cartão da tela. Quando o usuário arrasta o cartão, a propriedade "offset" é atualizada com a 
    distância que o cartão foi arrastado. Quando o gesto termina, se a distância for maior que 100 pontos, 
    a closure "removal" é chamada e um feedback de notificação é gerado (sucesso se o cartão for arrastado 
    para a direita, erro se for arrastado para a esquerda). Caso contrário, a propriedade "offset" é 
    redefinida como zero. Ele usa o gesto de tocar para permitir que o usuário veja a resposta do cartão. 
    Quando o usuário toca no cartão, a propriedade "isShowingAnswer" é alternada e a resposta é exibida ou 
    ocultada. Ele usa a animação de "spring" para animar a posição e a rotação do cartão conforme é 
    arrastado. Ele usa o modificador "accessibilityAddTraits" para adicionar acessibilidade ao cartão.
*/

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil

    @State private var feedback = UINotificationFeedbackGenerator()

    /*
        O UINotificationFeedbackGenerator é um gerador de feedback no iOS que é usado para fornecer feedbacks 
        de notificação para o usuário. Ele é usado para notificar o usuário sobre eventos como sucesso, 
        fracasso, alertas e outros tipos de notificações. Ele fornece feedbacks sonoros e táteis para o 
        usuário, dependendo das configurações do dispositivo. Além disso, você precisa chamar o método prepare()
        antes de chamar notificationOccurred() para garantir que o gerador esteja pronto para fornecer feedback.

        Os tipos de feedbacks disponíveis são:

        UINotificationFeedbackGenerator.FeedbackType.success
        UINotificationFeedbackGenerator.FeedbackType.warning
        UINotificationFeedbackGenerator.FeedbackType.error

        Eles são usados para notificar o usuário sobre eventos de sucesso, alerta e erro respectivamente.
    */

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)

            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(

            /*
                gesture é um modificador de visualização do SwiftUI que permite que você adicione gestos de 
                reconhecimento de toque às suas visualizações. Ele é usado para gerenciar interações de 
                toque com a interface do usuário, como tocar, deslizar, girar, etc. A sintaxe geral é a seguinte:

                .gesture(gestureType)

                Onde "gestureType" é o tipo de gesto que você deseja adicionar. O SwiftUI fornece vários 
                tipos de gestos pré-definidos, como DragGesture, LongPressGesture, TapGesture, entre outros.
                Exemplo:

                struct MyView: View {
                    @State private var offset = CGSize.zero

                    var body: some View {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 200, height: 200)
                            .offset(offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offset = gesture.translation
                                    }
                            )
                    }
                }
                O exemplo cria uma visualização de um retângulo vermelho que pode ser arrastado pelo 
                usuário. Quando o usuário arrasta o retângulo, o gesto de arrastar é detectado e o offset é 
                atualizado com a distância de deslocamento do gesto. Isso causa o retângulo a se mover na 
                tela na mesma direção e distância do gesto. Além disso, os gestos também podem ser 
                combinados, você pode adicionar vários gestos na mesma visualização, exemplo:

                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                    )
                    .gesture(
                        LongPressGesture(minimumDuration: 1)
                            .onEnded { _ in
                                print("Long press detected")
                            }
                    )

                O modificador gesture é uma maneira flexível de adicionar interações de toque às suas 
                visualizações e reagir aos gestos do usuário. 
                https://developer.apple.com/documentation/swiftui/gesture/
            */

            DragGesture()

            /*
                O DragGesture é um tipo de gesto pré-definido fornecido pelo SwiftUI que é usado para 
                detectar gestos de arrastar. Ele é usado para detectar o movimento do usuário ao tocar e 
                deslizar o dedo na tela.
            */
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }

                /*
                    .onChanged é um método fornecido pelo SwiftUI que é usado em conjunto com o 
                    DragGesture para detectar mudanças no estado do gesto enquanto o usuário o está 
                    arrastando. Ele é chamado várias vezes enquanto o gesto está sendo ativado, fornecendo 
                    informações sobre a posição e a distância do gesto.
                */

                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            feedback.notificationOccurred(.success)
                        } else {
                            feedback.notificationOccurred(.error)
                        }

                        removal?()
                    } else {
                        offset = .zero
                    }
                }

                /*
                    .onEnded é um método fornecido pelo SwiftUI que é usado em conjunto com o DragGesture 
                    para detectar o término de um gesto de arrastar. Ele é chamado uma vez quando o usuário 
                    solta o dedo da tela, após um gesto de arrastar ter sido detectado. Isso permite que 
                    você reaja à interação do usuário e execute alguma ação específica, como atualizar o 
                    estado de sua visualização ou chamar uma closure.
                */
        )
        .onTapGesture {
            isShowingAnswer.toggle()

            /*
                toggle() é um método no SwiftUI que é usado para alternar o estado de uma propriedade 
                booleana. Ele alterna o valor de uma propriedade booleana de verdadeiro para falso e 
                vice-versa. É usado para alternar estados, como mostrar/ocultar elementos da interface, 
                ativar/desativar elementos, entre outros.
            */

        }

        /*
            .onTapGesture é um modificador do SwiftUI que permite detectar toques simples em uma 
            visualização. Ele é usado para detectar quando o usuário toca uma visualização com um único 
            toque. Ele é útil para ativar ações, como alternar estados, navegar entre telas ou exibir 
            informações adicionais.
        */

        .animation(.spring(), value: offset)
    }
}
