import SpriteKit

class Maze {
    private var walls: [CGPoint] = []
    private var floor: [CGPoint] = []
    private let brickWidth: CGFloat
    private let size: CGSize
    private let floorWallsProportion: Double

    init(
        size: CGSize,
        brickWidth: CGFloat,
        floorWallsProportion: Double
    ){
        self.size = size
        self.brickWidth = brickWidth
        self.floorWallsProportion = floorWallsProportion
        buildGrid()
    }

    private func buildGrid() {
        for column in stride(from: brickWidth/2, to: size.height, by: brickWidth) {
            for row in stride(from: brickWidth/2, to: size.width, by: brickWidth) {
                walls.append(CGPoint(x: row, y: column))
            }
        }

        while Double(floor.count/walls.count)<floorWallsProportion {
            if floor.isEmpty {
                buildFloor(startPoint: walls.randomElement()!)
            } else {
                buildFloor(startPoint: floor.randomElement()!)
            }

        }
    }

    private func buildFloor(startPoint: CGPoint) {

        let topPoint = CGPoint(
            x: startPoint.x + brickWidth,
            y: startPoint.y
        )

        let leadingPoint = CGPoint(
            x: startPoint.x,
            y: startPoint.y - brickWidth
        )

        let trailingPoint = CGPoint(
            x: startPoint.x,
            y: startPoint.y + brickWidth
        )

        let bottomPoint = CGPoint(
            x: startPoint.x - brickWidth,
            y: startPoint.y
        )

        let availablePoints: [CGPoint] = getAvailablePoints(points: [
            topPoint, leadingPoint, trailingPoint, bottomPoint
        ])

        if !availablePoints.isEmpty {
            guard let point = availablePoints.randomElement() else {
                fatalError("point isn't available")
            }
            buildBrick(point: point)
        }
    }

    private func buildBrick(point: CGPoint) {
        walls.removeAll { $0 == point}
        floor.append(point)
        buildFloor(startPoint: point)
    }

    private func getAvailablePoints(points: [CGPoint]) -> [CGPoint] {
        var availablePoints: [CGPoint] = []

        for point in points {
            if walls.contains(point) {
                availablePoints.append(point)
            }
        }

        return availablePoints
    }

    func getFloor() -> [CGPoint] {
        return floor
    }

    func getWalls() -> [CGPoint] {
        return walls
    }

    func getWallsAsSKSpriteNode() -> [SKSpriteNode]{

        var spriteNodes: [SKSpriteNode] = []

        for point in walls {
            let wallBrick = SKSpriteNode(
                imageNamed: "wall"
            )
            wallBrick.size = CGSize(width: brickWidth, height: brickWidth)

            wallBrick.position = point

            wallBrick.physicsBody = SKPhysicsBody(rectangleOf: wallBrick.size)
            wallBrick.physicsBody?.isDynamic = false
            spriteNodes.append(wallBrick)
        }

        return spriteNodes
    }
}

/*
    A classe Maze que é usada para gerar um labirinto aleatório. A classe possui propriedades privadas walls 
    e floor, que armazenam a localização dos tijolos que compõem as paredes e o chão do labirinto, 
    respectivamente.

    O construtor da classe aceita três parâmetros: o tamanho total do labirinto, a largura dos tijolos que 
    compõem o labirinto e a proporção de chão em relação às paredes.

    O método privado buildGrid() é responsável por construir a grade inicial de tijolos que compõem as 
    paredes do labirinto, enquanto o método buildFloor(startPoint:) é responsável por construir o chão do 
    labirinto a partir de um determinado ponto.

    O método buildBrick(point:) é usado para construir tijolos individuais do chão a partir de um determinado 
    ponto e é chamado recursivamente até que o chão do labirinto tenha atingido a proporção desejada em 
    relação às paredes.

    O método getAvailablePoints(points:) é usado para determinar quais pontos estão disponíveis para a 
    construção de um novo tijolo do chão, enquanto o método getFloor() é usado para recuperar a 
    localização dos tijolos que compõem o chão do labirinto e o método getWalls() é usado para recuperar a 
    localização dos tijolos que compõem as paredes do labirinto.

    O método getWallsAsSKSpriteNode() é usado para converter a localização dos tijolos que compõem as paredes 
    em uma matriz de objetos SKSpriteNode que podem ser usados para criar as paredes do labirinto no SpriteKit.




*/