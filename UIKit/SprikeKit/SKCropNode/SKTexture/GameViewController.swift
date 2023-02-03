import UIKit
import SpriteKit

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

        /*
            A função shouldAutorotate é uma propriedade da classe UIViewController no iOS, que permite 
            especificar se a tela pode ser rotacionada automaticamente ao mudar a orientação do dispositivo. 
            Se shouldAutorotate for definido como true, a tela será rotacionada automaticamente quando o 
            dispositivo for virado, caso contrário, a tela não será rotacionada.
        */
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }

        // Esta função define as orientações de interface de usuário que o aplicativo suporta.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true

        // A função prefersStatusBarHidden é uma propriedade herdada da classe UIViewController e indica se a 
        // barra de status deve ser ocultada ou exibida. 
    }
}
