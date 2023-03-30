import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            SpriteView(scene: GameScene(size: proxy.size))
                .ignoresSafeArea()

                /*
                    O SpriteView é uma view do SwiftUI que permite renderizar cenas do SpriteKit no SwiftUI. Ele suporta todas as 
                    funcionalidades do SpriteKit e oferece várias opções de personalização para aprimorar a aparência e a 
                    interatividade da cena.
                */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
