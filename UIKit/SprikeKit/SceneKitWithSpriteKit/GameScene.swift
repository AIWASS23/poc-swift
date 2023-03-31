import SpriteKit
import CoreMotion
import SceneKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var manager: CMMotionManager? = CMMotionManager()
    private var timer: Timer?
    internal var seconds: Double?

    private let brickWidth: CGFloat = 30

    private lazy var boyAsSphereSKNode = SKNode()
    private lazy var momAsSphereSKNode = SKNode()
    private lazy var dollAsSphereSKNode = SKNode()

    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self

        let frameAdjusted = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: self.frame.width,
            height: self.frame.height
        )
        physicsBody = SKPhysicsBody(edgeLoopFrom: frameAdjusted)

        if let manager = manager, manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates()
        }

        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(increaseTimer),
            userInfo: nil,
            repeats: true
        )

        let maze: Maze = Maze(
            size: size,
            brickWidth: brickWidth,
            floorWallsProportion: 0.1
        )

        let floor: [CGPoint] = maze.getFloor()

        let wallBricksAsNodes: [SKSpriteNode] = maze.getWallsAsSKSpriteNode()

        for wallBrick in wallBricksAsNodes {
            addChild(wallBrick)
        }

        let boyAsSphereSCNNode = SphereSCNNode(color: .blue) as SCNNode

        boyAsSphereSKNode = SphereSKNode(
            brickWidth: brickWidth,
            sphereSCNNode: boyAsSphereSCNNode,
            position: floor.randomElement()!
        ) as SKNode

        addChild(boyAsSphereSKNode)

        let momAsSphereSCNNode = SphereSCNNode(color: .red) as SCNNode

        momAsSphereSKNode = SphereSKNode(
            brickWidth: brickWidth,
            sphereSCNNode: momAsSphereSCNNode,
            position: floor.randomElement()!
        ) as SKNode

        addChild(momAsSphereSKNode)

        let dollAsSphereSCNNode = SphereSCNNode(color: .white) as SCNNode

        dollAsSphereSKNode = SphereSKNode(
            brickWidth: brickWidth,
            sphereSCNNode: dollAsSphereSCNNode,
            position: floor.randomElement()!
        ) as SKNode

        addChild(dollAsSphereSKNode)

        let background = SKSpriteNode(imageNamed: "floor")
        background.position = CGPoint(x: size.width, y: size.height)
        background.zPosition = -1
        addChild(background)

    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node

//         Verifique se a boyAsCircle tocou na dollAsCircle
        if (bodyA == boyAsSphereSKNode && bodyB == dollAsSphereSKNode) || (bodyA == dollAsSphereSKNode && bodyB == boyAsSphereSKNode) {
            let alert = UIAlertController(title: "Vc pegou a boneca", message: "Parabéns!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }

//         Verifique se a momAsCircle tocou na boyAsCircle
        if (bodyA == momAsSphereSKNode && bodyB == boyAsSphereSKNode) || (bodyA == boyAsSphereSKNode && bodyB == momAsSphereSKNode) {
            let alert = UIAlertController(title: "Mamãe te pegou", message: "Perdeu", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }

//         Verifique se a momAsCircle tocou na dollAsCircle
        if (bodyA == momAsSphereSKNode && bodyB == dollAsSphereSKNode) || (bodyA == dollAsSphereSKNode && bodyB == momAsSphereSKNode) {
            let alert = UIAlertController(title: "Mamãe pegou a boneca", message: "Vc voltará ao inicio", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if let gravityX = manager?.deviceMotion?.gravity.y,
           let gravityY = manager?.deviceMotion?.gravity.x
           {
            boyAsSphereSKNode.physicsBody?.applyImpulse(CGVector(
                dx: CGFloat(-gravityX)*150,
                dy: CGFloat(gravityY)*150)
            )
            momAsSphereSKNode.physicsBody?.applyImpulse(CGVector(
                dx: CGFloat(-gravityX)*150,
                dy: CGFloat(gravityY)*150)
            )
            dollAsSphereSKNode.physicsBody?.applyImpulse(CGVector(
                dx: CGFloat(-gravityX)*150,
                dy: CGFloat(gravityY)*150)
            )
        }
    }

    @objc func increaseTimer() {
        seconds = (seconds ?? 0.0) + 0.01
    }
}

/*
    O GameScene usa o SpriteKit para gerenciar a cena do jogo, o CoreMotion para obter dados do acelerômetro 
    e do giroscópio do dispositivo e o SceneKit para renderizar as esferas coloridas. Além disso, o código 
    define um temporizador que atualiza a cada 0,01 segundos e uma detecção de colisão entre os objetos da 
    cena.

    A função didBegin(_ contact:) verifica se houve contato entre as esferas e exibe uma mensagem apropriada.
    Se o menino tocar na boneca, uma mensagem de parabéns é exibida, se a mãe tocar no menino, uma mensagem 
    de perda é exibida e se a mãe tocar na boneca, o jogador é levado de volta ao início. 
    
    A função update(_ currentTime:) atualiza a posição das esferas com base nos dados do acelerômetro e do 
    giroscópio do dispositivo.
*/
