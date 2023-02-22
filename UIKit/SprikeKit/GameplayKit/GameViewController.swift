import UIKit
import SpriteKit
import GameplayKit

/*
    GameplayKit é um framework do iOS que fornece recursos para desenvolvimento de jogos. Ele foi 
    introduzido no iOS 9 e oferece suporte a recursos como inteligência artificial, geração de conteúdo 
    procedural, simulação de física e muito mais.

    O framework é baseado em três pilares: aleatoriedade, entidades e comportamentos. A aleatoriedade é 
    usada para gerar elementos aleatórios em um jogo, como mapas, itens ou inimigos. Entidades são os 
    elementos que compõem um jogo, como personagens, inimigos, objetos, etc. Comportamentos são usados para 
    dar instruções a essas entidades, como se moverem, atacarem ou fugirem.

    Com o GameplayKit, é possível criar jogos mais complexos e realistas, com personagens que reagem ao 
    ambiente, inimigos que aprendem e se adaptam ao comportamento do jogador, e muito mais.
*/


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
