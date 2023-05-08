import Foundation

struct Point: Equatable {
    var x: Double
    var y: Double
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class KMeans {
    var k: Int
    var points: [Point]
    var centroids: [Point]
    
    init(k: Int, points: [Point]) {
        self.k = k
        self.points = points
        
        // Inicializa os centróides com k pontos aleatórios
        var randomPoints = points
        randomPoints.shuffle()
        self.centroids = Array(randomPoints.prefix(k))
    }
    
    func run(maxIterations: Int = 100) {
        for _ in 0..<maxIterations {
            // Agrupa os pontos em clusters de acordo com os centróides atuais
            var clusters = Array(repeating: [Point](), count: k)
            for point in points {
                var minDistance = Double.infinity
                var closestCentroidIndex = 0
                for i in 0..<k {
                    let centroid = centroids[i]
                    let distance = euclideanDistance(point, centroid)
                    if distance < minDistance {
                        minDistance = distance
                        closestCentroidIndex = i
                    }
                }
                clusters[closestCentroidIndex].append(point)
            }
            
            // Atualiza os centróides para a média dos pontos de cada cluster
            var newCentroids = [Point]()
            for i in 0..<k {
                let cluster = clusters[i]
                let count = Double(cluster.count)
                let sumX = cluster.reduce(0.0, { $0 + $1.x })
                let sumY = cluster.reduce(0.0, { $0 + $1.y })
                let newCentroid = Point(x: sumX / count, y: sumY / count)
                newCentroids.append(newCentroid)
            }
            
            // Se os centróides não mudaram, interrompe a execução
            if centroids == newCentroids {
                break
            } else {
                centroids = newCentroids
            }
        }
    }
    
    /*
        Calcula a distância euclidiana entre dois pontoscalcula a distância Euclidiana entre dois pontos em 
        um espaço bidimensional, representados pelas estruturas de dados Point.
    */
    private func euclideanDistance(_ p1: Point, _ p2: Point) -> Double {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return sqrt(dx*dx + dy*dy)
    }
    
    /*
        Calcula a distância de Manhattan (ou distância retangular) entre dois pontos em um espaço 
        bidimensional, representados pelas estruturas de dados Point. 
    */
    private func manhattanDistance(_ p1: Point, _ p2: Point) -> Double {
        return abs(p1.x - p2.x) + abs(p1.y - p2.y)
    }
    
    /*
        Calcula a distância de Chebyshev (ou distância de Xadrez) entre dois pontos em um espaço N-dimensional, 
        representados por vetores de coordenadas.
    */
    private func chebyshevDistance(_ point1: [Double], _ point2: [Double]) -> Double {

        /*
            Verifica uma condição necessária para avançar. Use esta função para detectar condições que devem 
            impedir o programa de prosseguir, mesmo no código de envio.
        */
        precondition(point1.count == point2.count, "The points must have the same number of coordinates")
        
        var maxDistance = 0.0
        
        for i in 0..<point1.count {
            let distance = abs(point1[i] - point2[i])
            if distance > maxDistance {
                maxDistance = distance
            }
        }
        
        return maxDistance
    }
}

// Exemplo de uso
let points = [
    Point(x: 1, y: 2),
    Point(x: 2, y: 3),
    Point(x: 3, y: 1),
    Point(x: 4, y: 3),
    Point(x: 5, y: 4),
    Point(x: 6, y: 4),
    Point(x: 4, y: 2),
    Point(x: 5, y: 3),
    Point(x: 11, y: 12),
    Point(x: 12, y: 13),
    Point(x: 13, y: 11),
    Point(x: 14, y: 13),
    Point(x: 15, y: 14),
    Point(x: 16, y: 14),
    Point(x: 14, y: 12),
    Point(x: 15, y: 13)
]
let kMeans = KMeans(k: 2, points: points)
kMeans.run()
print("Centroids:", kMeans.centroids)
