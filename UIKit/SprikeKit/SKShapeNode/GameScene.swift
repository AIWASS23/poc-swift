import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var player: SKSpriteNode!
    var enemies = [SKSpriteNode]()
    var gameTimer: Timer?
    var isGameOver = false

    override func didMove(to view: SKView) {
        backgroundColor = .white

        player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: frame.midX, y: (frame.minY) + 200)
        addChild(player)

        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
    }

    override func update(_ currentTime: TimeInterval) {
        if isGameOver {
            return
        }

        for enemy in enemies {
            enemy.position.y -= 5

            if enemy.position.y < (frame.minY) + 50 {
                enemy.removeFromParent()
                enemies.removeAll { $0 == enemy }
            }

            if enemy.intersects(player) {
                gameOver()
            }
        }
    }

    @objc func addEnemy() {
        let enemy = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        enemy.position = CGPoint(x: CGFloat.random(in: -300...frame.width), y: CGFloat.random(in: -300...frame.height))
        addChild(enemy)
        enemies.append(enemy)
    }

    func gameOver() {
        isGameOver = true

        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverLabel)

        gameTimer?.invalidate()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
}
