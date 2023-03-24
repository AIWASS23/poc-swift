import UIKit
import SpriteKit
import GameplayKit

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // chamada quando o sistema operacional começa a ficar sem memória disponível para o aplicativo.

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }

        /* a função verifica se o dispositivo atual é um telefone (UIDevice.current.userInterfaceIdiom == .phone). Se for um telefone, ele permitirá todas as orientações, exceto de cabeça para baixo, usando a constante allButUpsideDown. Caso contrário, se o dispositivo não for um telefone, permitirá todas as orientações usando a constante all. */
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    /* a closure retorna o valor booleano true, indicando que a barra de status deve ser ocultada. Se o valor retornado fosse false, a barra de status seria exibida normalmente.

     A finalidade dessa closure é permitir que o desenvolvedor da aplicação controle a aparência da interface do usuário e melhore a experiência do usuário. Por exemplo, se a aplicação tiver uma interface personalizada que já exibe informações de status, a barra de status padrão do sistema pode ser ocultada para evitar redundância e melhorar a aparência geral da aplicação.

     O método prefersStatusBarHidden é um método de propriedade que deve ser substituído na classe de visualização do controlador de exibição (ViewController) para personalizar a aparência da barra de status em um aplicativo iOS.

     */
}
