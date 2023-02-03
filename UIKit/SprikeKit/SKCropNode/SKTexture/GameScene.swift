import SpriteKit

/*
    Este código é uma classe chamada GameScene que herda de SKScene, uma classe do SpriteKit. A classe 
    GameScene representa uma cena em um jogo. A classe tem uma propriedade "score" que armazena a pontuação 
    atual do jogador, uma propriedade "gameScore" que é um rótulo (SKLabelNode) usado para exibir a pontuação,
    uma propriedade "slots" que é um array de objetos WhackSlot, uma propriedade "popupTime" que controla o 
    tempo em que os personagens aparecerão na tela e uma propriedade "numRounds" que armazena o número de 
    rodadas jogadas. O método "didMove(to:)" é chamado quando a cena é exibida na tela e configura a cena, 
    incluindo o fundo, o rótulo de pontuação e os personagens. O método "touchesBegan(_:with:)" é chamado 
    quando o usuário toca na tela e determina se o usuário acertou ou errou um personagem. O método 
    "createSlot(at:)" cria um objeto WhackSlot e adiciona-o à cena. O método "createEnemy()" cria um novo 
    personagem na tela de acordo com as regras definidas na lógica do jogo.

    O código implementa uma lógica simples de jogo de acertar personagens que aparecem na tela. A pontuação é 
    atualizada de acordo com as ações do usuário e exibida na tela usando a propriedade "gameScore".
*/

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"

            /*
                A palavra-chave didSet é usada em Swift para definir um bloco de código que é executado 
                quando o valor de uma propriedade é alterado. É usado para monitorar mudanças em uma 
                propriedade e executar ações adicionais com base nas mudanças. Por exemplo, você pode usar 
                didSet para atualizar outras propriedades ou para notificar outras partes do seu código sobre 
                mudanças em uma propriedade. É semelhante ao método setter em outras linguagens de programação.
            */
        }
    }
    
    var slots = [WhackSlot]()
    var popupTime = 0.85
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.createEnemy()

            /*
                O trecho de código DispatchQueue.main.asyncAfter é usado para agendar uma tarefa para ser 
                executada após um determinado tempo, especificado pelo segundo argumento, na thread principal 
                (main queue) do aplicativo. Ele permite que você adie a execução de uma tarefa, especificada 
                no primeiro argumento (um closure), por um período específico de tempo. Isso é útil, por 
                exemplo, quando você precisa atualizar a interface do usuário após um processamento longo.

                DispatchQueue.main é a fila de despacho principal, que é executada na thread principal da 
                aplicação, responsável por lidar com tarefas na interface gráfica do usuário. Já a 
                DispatchQueue.global é uma fila de despacho global, que pode ser compartilhada por vários 
                threads e é usada para tarefas que não precisam ser executadas na thread principal, como 
                tarefas de computação intensiva. Em outras palavras, usamos a DispatchQueue.main para 
                atualizar a interface do usuário, enquanto usamos a DispatchQueue.global para realizar 
                tarefas de background.
            */
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if node.name == "charFriend" {
                    // se matar o pinguim errado
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.hit()
                    score -= 5
                    
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))	

                    /*
                        Este trecho de código está executando uma ação no SpriteKit. A ação é tocar um arquivo
                        de som especificado como "whackBad.caf". O parâmetro "waitForCompletion: false" indica
                        que a ação não deve esperar pela conclusão do som antes de continuar. Isso significa 
                        que a execução do código continua imediatamente após a reprodução do som, sem esperar 
                        pelo fim da reprodução.
                    */

                } else if node.name == "charEnemy" {
                    // they should have whacked this one
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    whackSlot.hit()
                    score += 1
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
                }
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            self.createEnemy()
        }
    }
}
