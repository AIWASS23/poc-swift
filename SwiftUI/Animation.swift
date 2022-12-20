import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct TransitionsContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    self.isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)

                    /*
                        O transition() faz transições entre frames
                        O .asymmetric, permite usar uma transição 
                        quando a visualização está sendo mostrada 
                        e outra quando ela está desaparecendo.
                    */

                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct SnakeLettersContentView: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(self.letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(self.enabled ? Color.blue : Color.red)
                    /*
                        O offset() permite ajustar as coordenadas X e Y 
                        de uma visualização sem mover outras visualizações ao seu redor. 
                        deve ser vinculado a uma propriedade @Sate do tipo CGSize
                    */
                    .offset(self.dragAmount)
                    .animation(Animation.default.delay(Double(num) / 20))
            }
        }
        .gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation } // O onChanged() permite executar uma clousure sempre que o usuário move o dedo
                .onEnded { _ in
                    self.dragAmount = .zero
                    self.enabled.toggle()
                } // O onEnded() permite executar uma clousure quando o usuário levanta o dedo da tela, encerrando o arrasto.
        )
    }
}

struct AnimatingGesturesContentView: View {
    @State private var dragAmount = CGSize.zero

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            self.dragAmount = .zero
                        }
                    }
            )
    }
}


struct ControllingTheAnimationStackContentView: View {
    @State private var enabled = false

    var body: some View {
        Button("Tap Me") {
            self.enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? Color.blue : Color.red)
        .animation(nil)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1))
    }
}

struct ExplicitAnimationContentView: View {
    @State private var animationAmount = 0.0

    var body: some View {
        Button("Tap Me") {

            /*
                O withAnimation realiza animações explícitas isso garante 
                que todas as alterações resultantes do novo estado sejam animadas automaticamente.
            */

            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                self.animationAmount += 360
            }
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        /*
            O rotation3DEffect(),recebe uma quantidade de rotação em graus, 
            bem como um eixo que determina como a exibição gira.
            O eixo X (horizontalmente), gira para frente e para trás.
            O eixo Y (verticalmente), gira para a esquerda e para a direita.
            O eixo Z (profundidade), gira para a esquerda e para a direita.
        */
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct AnimatedBindingsContentView: View {
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        print(animationAmount)

        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                Animation.easeInOut(duration: 1) // O easeInOut() faz a animação começar rapidamente e desacelerar até uma parada suave
                    /*
                        O repeatCount() determina o número de vezes que a animação
                        irá iteragir no programa, isso, cria uma animação de um segundo 
                        que salta para cima e para baixo antes de atingir seu tamanho final
                        Para animações contínuas, existe um repeatForever()
                    */
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)

            Spacer()

            Button("Tap Me") {
                self.animationAmount += 1
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount) // Modifica o botão de acordo com uma propriedade @State a cada toque. 
        }
    }
}

struct CustomAnimationContentView: View {
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        Button("Tap Me") {
            // self.animationAmount += 1
        }
        .padding(40)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        /*
            O overlay() que nos permite criar novas exibições 
            com o mesmo tamanho e posição da exibição, sobrepondo a mesma.
        */
        .overlay(
            Circle()
                .stroke(Color.red)
                .scaleEffect(animationAmount)
                .opacity(Double(2 - animationAmount))
                .animation(
                    Animation.easeOut(duration: 1)
                        .repeatForever(autoreverses: false)
                )
        )
        .onAppear {
            self.animationAmount = 2
        }
    }
}

struct ContentView: View {
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        Button("Tap Me") {
            self.animationAmount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 3) //  Permite adicionar um desfoque gaussiano com um raio especial
        .animation(.default) // Isso pede ao SwiftUI para aplicar uma animação padrão.
    }
}
