import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.frame = UIScreen.main.bounds

        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill

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

/*
    A GameView é representada por uma UIViewRepresentable que é. A UIView contém uma cena do SpriteKit 
    chamada GameScene.

    O método makeUIView é responsável por criar a SKView que contém a cena do GameScene, definir seu 
    tamanho e escala, adicionar a cena na SKView e retorná-la.

    O método updateUIView é vazio e não faz nada.

    O struct ContentView é responsável por conter a GameView e ignorar as áreas seguras da tela.

    //*
        A finalidade de uma UIViewRepresentable no SwiftUI é permitir a integração de views do UIKit 
        (que são baseadas em UIView) com o SwiftUI. Como o SwiftUI é uma estrutura relativamente nova, 
        e muitas funcionalidades ainda não foram completamente implementadas. A UIViewRepresentable é 
        uma solução para usar views personalizadas ou views do UIKit que ainda não foram implementadas 
        no SwiftUI.

        Ao implementar a UIViewRepresentable, é possível criar uma view personalizada com base em uma 
        UIView (ou em uma subclasse de UIView, como UITableView, UICollectionView, MKMapView, etc.) 
        e usá-la no SwiftUI como qualquer outra view. A UIViewRepresentable permite que a view 
        personalizada seja renderizada corretamente, redimensionada e respondida a eventos de layout, 
        como outras views do SwiftUI.
        
    *//

*/