import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!

    /*
        SKEmitterNode é uma classe do SpriteKit que permite criar efeitos de partículas animadas em jogos e 
        aplicativos. A classe é usada para gerar partículas com várias propriedades, como cor, tamanho, 
        velocidade, taxa de emissão e outras características físicas que afetam o comportamento das 
        partículas. As partículas são geradas a partir de uma imagem ou de um conjunto de imagens, e o 
        SKEmitterNode controla sua animação e interação com outros objetos no jogo. As partículas podem ser 
        usadas para criar efeitos visuais como fogo, fumaça, explosões, chuva, neve, e muito mais.

        Um exemplo simples de uso do SKEmitterNode é adicionar um efeito de fumaça a um jogo. Para fazer 
        isso, é preciso criar um arquivo .sks que contém as configurações do emissor de partículas, 
        incluindo a imagem usada como base e as propriedades de animação. Em seguida, é possível criar um 
        SKEmitterNode a partir desse arquivo e adicioná-lo a uma cena do SpriteKit. O código abaixo mostra 
        um exemplo de como adicionar um emissor de partículas de fumaça a uma cena:


        if let smoke = SKEmitterNode(fileNamed: "Smoke.sks") {
            smoke.position = CGPoint(x: 100, y: 100)
            addChild(smoke)
        }

        Neste exemplo, o arquivo "Smoke.sks" contém as configurações do emissor de partículas de fumaça. Ele 
        é carregado em um SKEmitterNode chamado smoke, que é posicionado na cena na coordenada (100, 100) e 
        adicionado como filho da cena.
    */

    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)

        /*
            Este trecho de código cria um objeto Timer que é usado para agendar a execução de uma função 
            repetidamente após um intervalo de tempo específico. Ele é configurado para chamar a função c
            reateEnemy() a cada 0.35 segundos, sem nenhum parâmetro adicional (userInfo é definido como nil) 
            e com a repetição ativada (repeats é definido como true). O gameTimer é o nome da variável que 
            armazena a instância do objeto Timer.

            https://developer.apple.com/documentation/foundation/timer/
        */
    }

    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }

        if !isGameOver {
            score += 1
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        isGameOver = true
    }
}
