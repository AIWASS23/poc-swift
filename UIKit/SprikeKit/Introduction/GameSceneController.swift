import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? { // Carrega o SKScene de 'GameScene.sks'

            if let scene = SKScene(fileNamed: "GameScene") {

                scene.scaleMode = .aspectFill // Define o modo de escala, dimensionando-o para caber na janela
                view.presentScene(scene) // Apresenta a cena
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true

            /*
                O método .ignoresSiblingOrder é usado para dizer a um mecanismo de layout para ignorar a 
                ordem dos elementos irmãos ao fazer o layout de uma página. Isso pode ser útil ao criar 
                layouts complexos que exigem que os elementos sejam colocados em uma ordem específica, mas a 
                ordem dos elementos pode mudar dependendo do tamanho da viewport ou de outros fatores.

                O método .showsFPS é um método utilizado para exibir os quadros por segundo (FPS) de um jogo 
                ou aplicativo. Isso pode ser usado para medir o desempenho de um jogo ou aplicativo e ajudar 
                a identificar possíveis problemas.
            */
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }

        /*
            Essa função é usado para determinar a orientação do dispositivo. Ele verifica se o dispositivo é 
            um telefone ou não e, se for um telefone, retorna todas as orientações, exceto de cabeça para 
            baixo. Se não for um telefone, retorna todas as orientações.
        */
    }
    
    override var prefersStatusBarHidden: Bool {
        return true

        /*
            Essa função substitui a configuração padrão da barra de status em um aplicativo iOS. Ele define 
            o valor de prefereStatusBarHidden como true, o que ocultará a barra de status da exibição.
        */
    }
}
