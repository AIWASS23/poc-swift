import Foundation

// Define a função de custo (neste caso, o erro quadrático médio)
func meanSquaredError(predictions: [Double], labels: [Double]) -> Double {
    let n = Double(predictions.count)
    let squaredErrors = zip(predictions, labels).map { pow($0 - $1, 2) }
    return squaredErrors.reduce(0.0, +) / n
}

// Define a função de gradiente
func gradient(X: [[Double]], y: [Double], weights: [Double]) -> [Double] {
    let m = Double(y.count)
    let n = weights.count
    var grad = [Double](repeating: 0.0, count: n)
    
    for i in 0..<Int(m) {
        let error = (X[i].enumerated().map { $0.element * weights[$0.offset] }.reduce(0.0, +)) - y[i]
        for j in 0..<n {
            grad[j] += (error * X[i][j]) / m
        }
    }
    
    return grad
}

// Define o algoritmo de Batch Gradient Descent
func batchGradientDescent(X: [[Double]], y: [Double], learningRate: Double, numIterations: Int) -> [Double] {
    let m = Double(y.count)
    let n = X[0].count
    var weights = [Double](repeating: 0.0, count: n)
    
    for _ in 0..<numIterations {
        let grad = gradient(X: X, y: y, weights: weights)
        for j in 0..<n {
            weights[j] -= learningRate * grad[j]
        }
    }
    
    return weights
}

// Exemplo de uso
let X = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]
let y = [3.0, 7.0, 11.0, 15.0]

let learningRate = 0.01
let numIterations = 1000

let weights = batchGradientDescent(X: X, y: y, learningRate: learningRate, numIterations: numIterations)
let predictions = X.map { $0.enumerated().map { $0.element * weights[$0.offset] }.reduce(0.0, +) }
let mse = meanSquaredError(predictions: predictions, labels: y)

print("Weights: \(weights)")
print("Predictions: \(predictions)")
print("Mean Squared Error: \(mse)")
