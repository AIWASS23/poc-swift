import SpriteKit

/*
    SpriteKit é uma estrutura de desenvolvimento de jogos 2D. Ele fornece um conjunto de ferramentas para 
    criar jogos 2D de alto desempenho e baixo consumo de bateria. O SpriteKit inclui um mecanismo de física, 
    um gerador de partículas e suporte para shaders e efeitos. Também inclui um sistema de animação e um 
    motor de som. O SpriteKit é otimizado para criar animações rápidas e fluidas com código mínimo, 
    tornando-o ideal para o desenvolvimento de jogos para dispositivos móveis.
*/

class GameScene: SKScene, SKPhysicsContactDelegate {
	var scoreLabel: SKLabelNode!

    /*
        SKScene é uma classe do SpriteKit que representa uma cena de jogo. É usado para 
        criar e gerenciar elementos gráficos em uma tela, como nós, sprites e labels, e para realizar ações 
        como animações, física e interação com usuários. Você pode criar subclasses de SKScene para 
        implementar a lógica de jogo específica para sua aplicação.

        SKPhysicsContactDelegate é um protocolo do SpriteKit que permite a detecção de 
        colisões entre objetos de física. Quando dois objetos com corpos físicos colidem, o método 
        didBegin(_:) do protocolo é chamado, permitindo ao seu código reagir à colisão. Para ser um delegate 
        de contato físico, você precisa implementar o protocolo em sua classe e atribuir a instância da 
        classe à propriedade physicsWorld.contactDelegate da sua cena.

        SKLabelNode é uma classe do SpriteKit que representa um nó de texto na cena. É usado
        para exibir texto estático ou animado na tela. Você pode configurar propriedades como font, cor, 
        tamanho, alinhamento e muito mais. É possível também aplicar efeitos como sombra, brilho e vinheta 
        ao texto. SKLabelNode é útil para exibir pontuações, títulos, legendas e outros tipos de informações 
        de texto em um jogo ou aplicativo.
    */

	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	var editLabel: SKLabelNode!

	var editingMode: Bool = false {
		didSet {
			if editingMode {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}

	override func didMove(to view: SKView) {

        /*
            SKSpriteNode é uma classe do SpriteKit que representa um nó gráfico em forma de 
            retângulo com uma imagem ou cor de preenchimento. É usado para exibir imagens estáticas ou 
            animadas na tela. Você pode configurar propriedades como tamanho, posição, cor, textura e muito 
            mais. Além disso, é possível aplicar efeitos como sombra, brilho e vinheta ao sprite. 
            SKSpriteNode é útil para exibir personagens, objetos, fundos e outros elementos gráficos em um 
            jogo ou aplicativo.

            SKView é uma classe do SpriteKit que representa uma exibição de jogo. É usado 
            como a visualização principal para exibir uma cena SpriteKit, incluindo nós, sprites, labels e 
            outros elementos gráficos. Você pode configurar propriedades como escala, modo de exibição, 
            renderização e muito mais. Além disso, é possível exibir várias cenas em sequência, exibir 
            quadros por segundo e desenhar sobrepostos, como botões ou informações de status. SKView é uma 
            das peças-chave para criar jogos e aplicativos com o SpriteKit.
        */

		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)

		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self

        /*
            SKPhysicsBody é uma classe do SpriteKit que representa um corpo físico no mundo 
            físico. É usado para aplicar propriedades físicas, como massa, velocidade, atrito e elasticidade, 
            a um nó ou sprite na cena. Além disso, é possível configurar tipos de categoria e colisão para 
            controlar como objetos físicos interagem uns com os outros. SKPhysicsBody é essencial para criar 
            jogos e aplicativos que usam física, como jogos de plataforma, jogos de corrida ou simulações 
            físicas.
        */

		makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
		makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 896, y:0), isGood: false)

		makeBouncer(at: CGPoint(x: 0, y: 0))
		makeBouncer(at: CGPoint(x: 256, y: 0))
		makeBouncer(at: CGPoint(x: 512, y: 0))
		makeBouncer(at: CGPoint(x: 768, y: 0))
		makeBouncer(at: CGPoint(x: 1024, y: 0))

		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPoint(x: 980, y: 700)
		addChild(scoreLabel)

		editLabel = SKLabelNode(fontNamed: "Chalkduster")
		editLabel.text = "Edit"
		editLabel.position = CGPoint(x: 80, y: 700)
		addChild(editLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        /*
            UITouch é uma classe do UIKit que representa um toque na tela. É usado para 
            rastrear o estado de um toque, incluindo a posição, a duração e o estado (começou, mudou, 
            terminou). Você pode usar UITouch para detectar e responder a toques na tela, como cliques, 
            arrastos, toques longos e outros tipos de interação do usuário. A classe UITouch é usada em 
            conjunto com outras classes, como UIEvent, UIView e UIGestureRecognizer, para fornecer uma ampla 
            gama de funcionalidades de interação com a tela.

            UIEvent é uma classe do UIKit que representa um evento de interação do usuário, 
            como toques na tela, movimentos de rotação e aceleração, pressionamento de teclas e outros tipos 
            de eventos. É usado para rastrear o estado do evento, incluindo o tipo de evento, o momento em 
            que ocorreu e as informações adicionais, como o estado da tecla ou o toque na tela. Você pode 
            usar UIEvent para detectar e responder a eventos de interação do usuário, como cliques, 
            arrastos, toques longos e outros tipos de interação. A classe UIEvent é usada em conjunto com 
            outras classes, como UITouch, UIView e UIGestureRecognizer, para fornecer uma ampla gama de 
            funcionalidades de interação com a tela.
        */

		if let touch = touches.first {
			let location = touch.location(in: self)
			let objects = nodes(at: location)

			if objects.contains(editLabel) {
				editingMode = !editingMode
			} else {
				if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
					box.position = location

					box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
					box.physicsBody?.isDynamic = false

					addChild(box)
				} else {
					let ball = SKSpriteNode(imageNamed: "ballRed")
					ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
					ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
					ball.physicsBody?.restitution = 0.4
					ball.position = location
					ball.name = "ball"
					addChild(ball)
				}
			}
		}
    }

	func makeBouncer(at position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
		bouncer.physicsBody?.isDynamic = false
		addChild(bouncer)

        /*
            Este código cria um nó sprite bouncer em uma determinada posição. Ele define o corpo físico do 
            nó como um círculo com um raio igual à metade da largura do sprite do segurança. O corpo físico 
            está definido para ser não dinâmico, o que significa que não se moverá quando interagir com ele. 
            Por fim, ele adiciona o nó sprite do segurança como filho da cena.
        */
	}

	func makeSlot(at position: CGPoint, isGood: Bool) {
		var slotBase: SKSpriteNode
		var slotGlow: SKSpriteNode

		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "good"
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "bad"
		}

		slotBase.position = position
		slotGlow.position = position

		slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false

		addChild(slotBase)
		addChild(slotGlow)

		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)
		slotGlow.run(spinForever)

        /*
            Este código cria um slot na posição dada com um nome "bom" ou "ruim" dependendo do valor 
            booleano passado. Ele cria dois nós de sprite, um para a base e outro para o brilho, e define 
            suas posições para o dada posição. Ele também configura um corpo físico para a base do slot e 
            adiciona os dois nós à cena. Por fim, ele executa uma ação que fará com que o nó de brilho gire 
            para sempre.

            SKAction é uma classe do SpriteKit que representa uma ação que pode ser executada por um nó ou s
            prite na cena. É usado para animar, mover, escalar, girar e realizar outras tarefas em nós e 
            sprites na cena. As ações podem ser executadas de forma sequencial ou paralela, e você pode 
            combinar várias ações em uma única ação. Além disso, é possível criar ações personalizadas 
            usando a classe SKAction. SKAction é uma parte fundamental do framework SpriteKit e é usado para 
            criar animações suaves, efeitos visuais e jogabilidade dinâmica.
        */
	}

	func collisionBetween(ball: SKNode, object: SKNode) {
		if object.name == "good" {
			destroy(ball: ball)
			score += 1
		} else if object.name == "bad" {
			destroy(ball: ball)
			score -= 1
		}
	}

	func destroy(ball: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {

            /*
                SKEmitterNode é uma classe do SpriteKit, usada para criar partículas e efeitos especiais em 
                jogos e aplicativos. Ele pode ser usado para criar efeitos como fogo, neve, fumaça, entre 
                outros. É possível configurar vários aspectos da emissão de partículas, como velocidade, 
                cor, vida útil, direção, entre outros. Para usar um SKEmitterNode, você precisa criar um 
                arquivo .sks com as configurações desejadas e, em seguida, inicializar a classe com esse 
                arquivo.
            */

			fireParticles.position = ball.position
			addChild(fireParticles)

            /*
                addChild é um método do SpriteKit em Swift usado para adicionar um nó filho a um nó pai. Ele 
                permite que você construa uma árvore de nós, onde o nó pai é o contêiner e o nó filho é o 
                conteúdo. Ao adicionar um nó filho a um nó pai, você pode aplicar transformações, como 
                rotação, escala e posição, ao nó filho e todos os seus descendentes.
                
                let childNode = SKNode()
                let parentNode = SKNode()
                parentNode.addChild(childNode)
            */
		}

		ball.removeFromParent()
	}

	func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

		if nodeA.name == "ball" {
			collisionBetween(ball: nodeA, object: nodeB)
		} else if nodeB.name == "ball" {
			collisionBetween(ball: nodeB, object: nodeA)
		}
	}
}
