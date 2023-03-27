import SpriteKit

class CircleNode: SKShapeNode {

    init(radius: CGFloat, position: CGPoint, color: UIColor) {
        super.init()

        self.position = position

        let circle = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2), transform: nil)

        self.path = circle
        self.fillColor = color
        self.strokeColor = .clear

        // Configuração da física do nó do círculo
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
        A classe CircleNode herda de SKShapeNode, ela representa um nó de forma circular que pode ser 
        adicionado a uma cena do SpriteKit. O construtor da classe recebe três parâmetros: 
        o raio do círculo, a posição do círculo na cena e a cor de preenchimento do círculo.

        O método init da classe cria um círculo com o raio especificado e define sua posição na cena. 
        Em seguida, ele define o caminho do círculo, a cor de preenchimento e configura a física do 
        círculo. A física do Círculo é configurada para ser afetada pela gravidade e ter uma categoria 
        de colisão, colisão e teste de contato definidos como 1.

        O método required init?(coder aDecoder: NSCoder) é necessário para conformidade com o protocolo 
        NSCoding e é deixado como uma implementação vazia.
    */
}