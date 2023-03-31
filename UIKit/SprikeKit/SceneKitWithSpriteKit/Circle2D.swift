import SpriteKit

class CircleNode2D: SKShapeNode {

    init(radius: CGFloat, position: CGPoint, color: UIColor) {
        super.init()

        self.position = position

        let circle = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*1.5, height: radius*1.5), transform: nil)

        self.path = circle
        self.fillColor = color
        self.strokeColor = .clear

        // Configuração da física do nó do círculo
        self.physicsBody = SKPhysicsBody(circleOfRadius: (radius*1.5)/2)
        self.physicsBody?.mass = 4.5
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 1 // as categorias às quais um nó pertence e a quais categorias ele deve responder para colisões e outros eventos físicos.
        self.physicsBody?.collisionBitMask = 1 // em quais nós devo esbarrar?
        self.physicsBody?.contactTestBitMask = 1 // sobre quais colisões você deseja saber?
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
    A classe CircleNode2D é um círculo bidimensional preenchido com uma cor. A classe recebe como argumentos 
    o raio, a posição e a cor do círculo. O CircleNode2D herda da classe SKShapeNode, permitindo que a forma 
    do nó seja definida como uma CGPath personalizada. No método init, a forma do círculo é definida como um 
    caminho elíptico com um tamanho que é 1,5 vezes maior que o raio especificado e o preenchimento é 
    definido como a cor passada como argumento.

    Em seguida, são configurados os atributos físicos do círculo, como sua massa, sua capacidade de rotação, 
    dinamicidade e interação com a gravidade. A categoria, colisão e teste de contatos também são definidos 
    para o corpo físico do nó, permitindo que ele interaja com outros nós físicos.
*/