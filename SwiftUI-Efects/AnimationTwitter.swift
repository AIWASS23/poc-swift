import SwiftUI

/*
    Este script cria uma visualização chamada AnimationView 
    que exibe duas animações. A primeira é uma animação de coração do Twitter, 
    que exibe um coração vazio que é preenchido com um coração azul e vários 
    círculos coloridos quando ativada. A segunda é uma animação de palmas, 
    que exibe duas mãos palmadas quando ativada. Ambos os botões podem ser ativados e 
    desativados clicando neles.
*/

struct AnimationView: View {
    @State private var playHeartAnimation: Bool = false
    @State private var playClapAnimation: [Bool] = [false, false]

    var body: some View {
        VStack {
            // Twitter Heart Animation
            ZStack {
                Image(systemName: "suit.heart")

                Image(systemName: "suit.heart.fill")
                    .foregroundColor(.blue)
                    .scaleEffect(playHeartAnimation ? 1 : 0) // O scaleEffect é um modificador de visualização no SwiftUI que aplica um efeito de escala (ampliação ou redução) a uma visualização.
                    .animation(.easeInOut, value: playHeartAnimation)

                ForEach(0...15, id: \.self) { _ in
                    let offsets = getRandomOffsets()

                    Circle()
                        .fill(getRandomColor())
                        .frame(width: 3, height: 3)
                        .offset(x: playHeartAnimation ? offsets.0 : 0, y: playHeartAnimation ? offsets.1 : 0)
                        .opacity(playHeartAnimation ? 1 : 0)
                        .animation(.spring().delay(0.25 + .random(in: 0...(0.1))), value: playHeartAnimation)
                }
            }
            .padding(64)
            .border(Color.secondary)
            .contentShape(Rectangle())
            .onTapGesture {
                playHeartAnimation.toggle()
            }

            // Clap Animation
            ZStack {
                Image(systemName: "hands.clap.fill")

                Image(systemName: "hands.clap.fill")
                    .offset(x: 0, y: playClapAnimation[0] ? -30 : 0)
                    .opacity(playClapAnimation[1] ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: playClapAnimation[0])
                    .animation(.easeInOut(duration: 0.4), value: playClapAnimation[1])
            }
            .padding(64)
            .border(Color.secondary)
            .contentShape(Rectangle())
            .onTapGesture {
                playClapAnimation[0].toggle()
                playClapAnimation[1].toggle()

                /*
                    O DispatchQueue é um componente do sistema de gerenciamento de concorrência do Swift 
                    que permite executar tarefas de forma assíncrona. Você pode criar uma fila de tarefas 
                    e adicionar tarefas a ela para serem executadas em segundo plano, 
                    enquanto o código principal continua sendo executado.

                    O DispatchQueue.main é uma fila de tarefas especial que é usada para adicionar 
                    tarefas que precisam ser executadas na thread principal.

                    O DispatchQueue.global é um componente do sistema de gerenciamento de concorrência 
                    do Swift que cria uma fila de tarefas global para tarefas que não precisam ser 
                    git aexecutadas na thread principal. 
                */

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    playClapAnimation[1].toggle()
                }
            }
        }
    }

    private func getRandomColor() -> Color {
        let r = Int.random(in: 0...4)
        switch r {
            case 0:
                return .red
            case 1:
                return .orange
            case 2:
                return .yellow
            case 3:
                return .green
            default:
                return .blue
        }
    }

    private func getRandomOffsets() -> (CGFloat, CGFloat) {
        let possibilities: [CGFloat] = [-12, -11, -10, -9, -8, 8, 9, 10, 11, 12]
        return (possibilities.randomElement()!, possibilities.randomElement()!)
    }
}