import SpriteKit
import UIKit

/*
    A classe WhackSlot representa uma slot em um jogo chamado "Whack-a-Penguin" ela tem três propriedades:

    charNode: uma SKSpriteNode que representa o personagem (pinguim) na slot.
    isVisible: um booleano que indica se o personagem está visível ou não.
    isHit: um booleano que indica se o personagem foi atingido ou não.

    A classe tem vários métodos, incluindo:

    configure: um método que configura a posição da slot e adiciona um fundo (sprite) e um personagem 
    (charNode).

    show: um método que faz o personagem aparecer na slot. Ele escolhe aleatoriamente se o personagem é um 
    amigo ou inimigo e agendamento o método hide para ser executado após um certo período de tempo.

    hide: um método que faz o personagem desaparecer da slot.
    hit: um método que marca o personagem como atingido e o faz desaparecer da slot.
*/

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)

        /*
            O SKCropNode é um tipo de nó do SpriteKit, usado para cortar conteúdos de outros nós. Ele é usado 
            para definir uma região de recorte para seus filhos, limitando a área visível dos nós filhos ao 
            interior da máscara. Desta forma, apenas a parte dos nós filhos que estiver dentro da região 
            definida pela máscara será visível na cena.
        */
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"

            /*
                SKTexture é uma classe do SpriteKit que representa uma imagem, textura ou uma seleção de 
                pixels que pode ser aplicada a um SKSpriteNode ou outra forma gráfica dentro do framework. 
                O objetivo da SKTexture é fornecer uma maneira de carregar, armazenar e aplicar imagens para 
                elementos gráficos dentro de um jogo ou aplicativo feito com o SpriteKit.
            */
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [unowned self] in
            self.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y:-80, duration:0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y:-80, duration:0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
}
