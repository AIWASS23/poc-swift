import SpriteKit
import CoreMotion
import GameplayKit

class GameScene: SKScene {

    let motionManager = CMMotionManager()
    let ball = SKShapeNode(circleOfRadius: 20)
    let maze = SKShapeNode(rectOf: CGSize(width: 100, height: 100))

    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white

        // Add maze
        maze.fillColor = UIColor.black
        maze.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(maze)

        // Add ball
        ball.fillColor = UIColor.red
        ball.position = CGPoint(x: frame.midX, y: frame.midY - 150)
        addChild(ball)

        // Set up gyroscope
        motionManager.startAccelerometerUpdates()
        motionManager.accelerometerUpdateInterval = 0.1

        // physiscsBody of objects

        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.friction = 1  //funcao
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.contactTestBitMask = 1

        maze.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        maze.physicsBody?.affectedByGravity = false
        maze.physicsBody?.friction = 0
        maze.physicsBody?.restitution = 1
        maze.physicsBody?.linearDamping = 0
        maze.physicsBody?.categoryBitMask = 1
        maze.physicsBody?.contactTestBitMask = 1

        // Limits of View for objetcs

        let frameAdjusted = CGRect(
            x: frame.origin.x,
            y: frame.origin.y + 110,
            width: self.frame.width,
            height: self.frame.height - 220
        )
        physicsBody = SKPhysicsBody(edgeLoopFrom: frameAdjusted)

    }

    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            let x = CGFloat(accelerometerData.acceleration.x)
            let y = CGFloat(accelerometerData.acceleration.y)
            let vector = CGVector(dx: x * 50, dy: y * 50)
            ball.physicsBody?.applyForce(vector)

        }
    }
}
