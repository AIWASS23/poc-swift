/*
    A GameView é uma visualização representável de uma SKView, usada para renderizar uma cena 2D ou 3D. 
    O método makeUIView é responsável por criar a SKView e configurá-la para que preencha a tela inteira. 
    Em seguida, uma cena GameScene é criada com base no tamanho da SKView e com a escala de exibição definida 
    como aspectFill (ou seja, a cena é dimensionada para preencher a tela, mas pode ser cortada se precisar 
    manter a proporção correta).

    A GameScene é definida como a cena atual da SKView e o método retorna a SKView criada.

    A ContentView é a visualização principal do SwiftUI. Ela instancia um objeto GameView e o posiciona no 
    layout ignorando as áreas seguras (safe areas) do dispositivo (como barras de status e barras de navegação).
*/

import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.frame = UIScreen.main.bounds

        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill

        view.presentScene(scene)

        return view
    }

    func updateUIView(_ view: SKView, context: Context) {
        // Empty
    }

}

struct ContentView: View {
    var body: some View {
        GameView().ignoresSafeArea()
    }
}