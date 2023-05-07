
import Foundation

struct SVM {
    
    // Hiperparametros
    var learningRate: Double
    var lambda: Double
    var numIterations: Int
    
    // Model parametros
    var w: [Double]
    var b: Double
    
    // Treino do modelo usando os recursos e rótulos de entrada
    mutating func train(features: [[Double]], labels: [Int]) {
        
        let numExamples = features.count
        let numFeatures = features[0].count
        
        // Inicializar pesos e viés para 0
        w = Array(repeating: 0.0, count: numFeatures)
        b = 0.0
        
        // Percorrer o conjunto de treinamento para numIterations
        for _ in 0..<numIterations {
            
            // Faz um loop em cada exemplo no conjunto de treinamento
            for i in 0..<numExamples {
                
                let x = features[i]
                let y = Double(labels[i])
                
                // Calcula a margem e a perda para este exemplo
                let margin = y * (dotProduct(w, x) + b)
                let loss = max(0, 1 - margin)
                
                // Atualiza os pesos e os viés se a perda for maior que 0
                if loss > 0 {
                    
                    let dLDW = multiply(w, lambda)
                    let dLdw = subtract(dLDW, multiply(x, y * learningRate))
                    let dLdb = -y
                    
                    w = subtract(w, multiply(dLdw, learningRate))
                    b -= dLdb * learningRate
                }
            }
        }
    }
    
    // Use o modelo treinado para prever os rótulos de novos recursos de entrada
    func predict(features: [Double]) -> Int {
        
        let output = dotProduct(w, features) + b
        return output >= 0 ? 1 : -1
    }
    
    // Calcula o produto escalar de dois vetores
    func dotProduct(_ vector1: [Double], _ vector2: [Double]) -> Double {
        let zippedVectors = zip(vector1, vector2)
        let products = zippedVectors.map { $0 * $1 }
        return products.reduce(0.0, +)
    }

    func matrixMultiplication(_ matrix1: [[Double]], _ matrix2: [[Double]]) -> [[Double]] {
        var result = Array(repeating: Array(repeating: 0.0, count: matrix2[0].count), count: matrix1.count)
        
        for i in 0..<matrix1.count {
            for j in 0..<matrix2[0].count {
                let row = matrix1[i]
                let col = matrix2.map { $0[j] }
                result[i][j] = dotProduct(row, col)
            }
        }
        
        return result
    }
    
    // Multiplica um vetor por um escalar
    private func multiply(_ a: [Double], _ s: Double) -> [Double] {
        
        return a.map { $0 * s }
    }
    
    // Subtração entre 2 vetores
    private func subtract(_ a: [Double], _ b: [Double]) -> [Double] {
        
        precondition(a.count == b.count, "Vectors must have the same length")
        
        var result = [Double]()
        for i in 0..<a.count {
            result.append(a[i] - b[i])
        }
        return result
    }
}
var svm = SVM(learningRate: 0.01, lambda: 0.01, numIterations: 1000, w:[], b: 0.0)

// Criar dados de treinamento
let features = [[1.0, 2.0], [2.0, 3.0], [3.0, 1.0], [4.0, 3.0], [5.0, 4.0], [6.0, 4.0], [4.0, 2.0], [5.0, 3.0]]
let labels = [1.0, 1.0, -1.0, -1.0, -1.0, 1.0, -1.0, -1.0]

// Treinar o modelo
svm.train(features: features, labels: labels.map { Int(Double($0)) })

// Fazer previsões com o modelo treinado
let testFeatures = [[1.0, 1.0], [5.0, 2.0], [2.0, 2.0]]
for feature in testFeatures {
    let prediction = svm.predict(features: feature)
    print("Predicted class: \(prediction)")
}
