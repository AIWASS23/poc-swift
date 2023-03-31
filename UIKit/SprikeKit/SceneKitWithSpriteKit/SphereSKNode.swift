import SpriteKit
import SceneKit

class SphereSKNode: SKNode {
    init(
        brickWidth: CGFloat,
        sphereSCNNode: SCNNode,
        position: CGPoint
    ) {
        super.init()

        let sphereSK3DNode = SK3DNode()
        let scene = SCNScene()
        scene.rootNode.addChildNode(sphereSCNNode)

        sphereSK3DNode.viewportSize = CGSize(
            width: brickWidth*0.8,
            height: brickWidth*0.8
        )

        sphereSK3DNode.scnScene = scene

        self.addChild(sphereSK3DNode)

        self.position = position
        
        self.physicsBody = SKPhysicsBody(
            circleOfRadius: (brickWidth/2)*0.6
        )
        self.physicsBody?.mass = 4.5
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
    A classe SphereSKNode que herda de SKNode. A classe cria um nó de cena 3D para uma esfera usando o SceneKit. O construtor da 
    classe recebe três parâmetros: brickWidth (largura da esfera), sphereSCNNode (um nó de cena "SCNNode" que contém a geometria 
    da esfera) e position (a posição da esfera na cena).

    O método init da classe começa criando um nó SK3DNode e uma cena SCNScene. Em seguida, adiciona o nó sphereSCNNode à cena e 
    define o tamanho da viewport para o nó sphereSK3DNode(o que afeta como a cena 3D é renderizada dentro do nó 2D). Então, o nó
    sphereSK3DNode é definido como a cena scnScene e adicionado ao nó principal da classe. A posição do nó principal é então 
    definida como a posição passada como parâmetro.

    Finalmente, um corpo de física SKPhysicsBody é adicionado ao nó principal para simular a física da esfera na cena. O corpo 
    de física é definido como uma forma circular com um raio de brickWidth/2 * 0.6 (60% da largura da esfera), uma massa de 4,5 
    unidades e com rotação desabilitada. Também é definido para ser afetado pela gravidade e colidir com outros objetos que 
    possuem uma categoria de máscara definida como 1, além de notificar quando ocorre uma colisão através do contato de 
    máscara definido como 1.




*/