import SpriteKit

class Maze {
    private var walls: [CGPoint] = []
    private var floor: [CGPoint] = []
    private let brickWidth: CGFloat
    private let size: CGSize

    init(size: CGSize, brickWidth: CGFloat){
        self.size = size
        self.brickWidth = brickWidth
        buildGrid()

        /*
            A classe Maze que é usada para construir um labirinto em uma cena SpriteKit. O labirinto é 
            construído a partir de uma grade de tijolos retangulares, com paredes formadas pelos 
            tijolos que não foram incluídos no chão do labirinto.

            O construtor init da classe Maze recebe dois parâmetros: size, que é a largura e altura do 
            labirinto em pontos, e brickWidth, que é a largura de cada tijolo retangular em pontos.
        */
    }

    private func buildGrid() {
        for column in stride(from: brickWidth/2, to: size.height, by: brickWidth) {
            for row in stride(from: brickWidth/2, to: size.width, by: brickWidth) {
                walls.append(CGPoint(x: row, y: column))
            }
        }

        while Double(floor.count/walls.count)<0.95 {
            if floor.isEmpty {
                buildFloor(startPoint: walls.randomElement()!)
            } else {
                buildFloor(startPoint: floor.randomElement()!)
            }

        }

        /*
            A função buildGrid é usada para construir uma grade de tijolos retangulares, com cada tijolo
            representado como um ponto CGPoint. A função usa a largura do tijolo e o tamanho do 
            labirinto para determinar quantas colunas e linhas de tijolos são necessárias e, 
            em seguida, adiciona um ponto para cada tijolo à matriz walls.
        */
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

        /*
            A função buildFloor é usada para adicionar tijolos ao chão do labirinto. Ele recebe um 
            ponto startPoint e, em seguida, determina os pontos adjacentes que podem ser usados para 
            adicionar um tijolo ao chão. Se um ponto disponível é encontrado, a função buildBrick é 
            chamada para adicionar o tijolo ao chão e removê-lo da matriz walls.
        */
    }

    private func buildBrick(point: CGPoint) {
        walls.removeAll { $0 == point}
        floor.append(point)
        buildFloor(startPoint: point)

        /*
            A função buildBrick é usada para adicionar um tijolo ao chão do labirinto. Ele recebe um 
            ponto point e o adiciona à matriz floor. Em seguida, ele chama a função buildFloor com o 
            ponto adicionado para continuar a construir o chão do labirinto.
        */
    }

    private func getAvailablePoints(points: [CGPoint]) -> [CGPoint] {
        var availablePoints: [CGPoint] = []

        for point in points {
            if walls.contains(point) {
                availablePoints.append(point)
            }
        }

        return availablePoints

        /*
            A função getAvailablePoints é usada para determinar quais pontos adjacentes estão 
            disponíveis para adicionar um tijolo ao chão. Ele recebe uma matriz de pontos e retorna 
            uma matriz contendo apenas os pontos que ainda não foram adicionados ao chão do labirinto.
        */
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
                color: .gray,
                size: CGSize(width: brickWidth, height: brickWidth)
            )

            wallBrick.position = point

            wallBrick.physicsBody = SKPhysicsBody(rectangleOf: wallBrick.size)
            wallBrick.physicsBody?.isDynamic = false
            spriteNodes.append(wallBrick)
        }

        return spriteNodes

        /*
            A função getWallsAsSKSpriteNode retorna um array de SKSpriteNode para cada ponto de parede 
            na matriz de paredes. Cada SKSpriteNode é um sprite retangular cinza que representa um 
            tijolo de parede, e é configurado com um corpo físico para permitir a detecção de colisões 
            com outros objetos no labirinto.
        */
    }
}
