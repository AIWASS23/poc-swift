import Foundation

// Função sigmoide para calcular a probabilidade
func sigmoid(_ x: Double) -> Double {
    return 1 / (1 + exp(-x)) // 1/(1 + (eˆ-x))

}

// Classe para o modelo de regressão logística
class LogisticRegression {
    
    var weights: [Double] // pesos para as características
    var bias: Double // bias
    
    init(featureCount: Int) {
        // Inicializa os pesos e o bias com valores aleatórios
        self.weights = Array(repeating: 0.0, count: featureCount)
        self.bias = 0.0
    }
    
    // Função para treinar o modelo com os dados de entrada
    func fit(x: [[Double]], y: [Int], learningRate: Double = 0.01, epochs: Int = 1000) {
        for epoch in 0..<epochs {
            var dw = Array(repeating: 0.0, count: weights.count)
            var db = 0.0
            
            for i in 0..<x.count {
                // Calcula a saída do modelo
                let z = dotProduct(weights, x[i]) + bias
                let a = sigmoid(z)
                
                // Calcula o erro e o gradiente
                let error = a - Double(y[i])
                dw = vectorSum(dw, vectorScalarProduct(x[i], error))
                db += error
            }
            
            // Atualiza os pesos e o bias
            let m = Double(x.count)
            weights = vectorSubtraction(weights, vectorScalarProduct(dw, learningRate / m))
            bias -= db * learningRate / m
        }
    }
    
    // Função para prever a classe de uma entrada
    func predict(x: [Double]) -> Int {
        let z = dotProduct(weights, x) + bias
        let a = sigmoid(z)
        return a >= 0.5 ? 1 : 0
    }
    
    // Funções auxiliares para cálculos de vetor
    private func dotProduct(_ a: [Double], _ b: [Double]) -> Double {
        return zip(a, b).map(*).reduce(0, +)

        /*
            zip: Cria uma sequência de pares construída a partir de duas sequências subjacentes, segundo o Playground.

            zip(a, b).map { $0 * $1 }.reduce(0, +)zip(a, b).map(*) é uma expressão que cria um novo array combinando elementos dos arrays 
            a e b, aplicando uma transformação a cada par de elementos. Em seguida, o método .reduce(0, +) é aplicado a este novo array para 
            calcular a soma de todos os elementos.
        */
    }
    
    private func vectorSum(_ a: [Double], _ b: [Double]) -> [Double] {
        return zip(a, b).map(+)
    }
    
    private func vectorSubtraction(_ a: [Double], _ b: [Double]) -> [Double] {
        return zip(a, b).map(-)
    }
    
    private func vectorScalarProduct(_ a: [Double], _ b: Double) -> [Double] {
        return a.map { $0 * b }
    }
}

// Cria um conjunto de dados de treinamento
let x = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0], [9.0, 10.0]]
let y = [0, 0, 1, 1, 1]

// Cria um modelo de regressão logística com 2 características
let lr = LogisticRegression(featureCount: 2)

// Treina o modelo com os dados de treinamento
lr.fit(x: x, y: y, learningRate: 0.01, epochs: 1000)

// Testa o modelo com novos dados
let x_test = [[2.0, 3.0], [4.0, 5.0], [6.0, 7.0]]
for i in 0..<x_test.count {
    let y_pred = lr.predict(x: x_test[i])
    print("Entrada \(x_test[i]) foi classificada como \(y_pred)")
}