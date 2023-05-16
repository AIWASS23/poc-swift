
import Foundation

class MLP {
    let inputSize: Int
    let hiddenSize: Int
    let outputSize: Int
    let learningRate: Double
    var weights1: [[Double]]
    var biases1: [Double]
    var weights2: [[Double]]
    var biases2: [Double]
    
    init(inputSize: Int, hiddenSize: Int, outputSize: Int, learningRate: Double) {
        self.inputSize = inputSize
        self.hiddenSize = hiddenSize
        self.outputSize = outputSize
        self.learningRate = learningRate
        
        // Inicializa pesos e vieses aleatoriamente
        self.weights1 = []
        self.biases1 = []
        self.weights2 = []
        self.biases2 = []

        for _ in 0..<hiddenSize {
            self.weights1.append(Array(repeating: 0.0, count: inputSize))
            self.biases1.append(0.0)
        }

        for _ in 0..<outputSize {
            self.weights2.append(Array(repeating: 0.0, count: hiddenSize))
            self.biases2.append(0.0)
        }

        for i in 0..<hiddenSize {
            for j in 0..<inputSize {
                self.weights1[i][j] = Double.random(in: -1...1)
            }
        }

        for i in 0..<outputSize {
            for j in 0..<hiddenSize {
                self.weights2[i][j] = Double.random(in: -1...1)
            }
        }
    }
    
    // Função sigmoide
    func sigmoid(_ x: Double) -> Double {
        return 1 / (1 + exp(-x))
    }

    // Função derivada da sigmoide
    func sigmoidDerivative(x: Double) -> Double {
        return sigmoid(x) * (1 - sigmoid(x))
    }
    
    // Passo direto
    func forward(_ input: [Double]) -> ([Double], [Double]) {
        // Camada oculta
        var hidden: [Double] = []
        for i in 0..<hiddenSize {
            var sum = biases1[i]
            for j in 0..<inputSize {
                sum += weights1[i][j] * input[j]
            }
            hidden.append(sigmoid(sum))
        }
        // Camada de saída
        var output: [Double] = []
        for i in 0..<outputSize {
            var sum = biases2[i]
            for j in 0..<hiddenSize {
                sum += weights2[i][j] * hidden[j]
            }
            output.append(sigmoid(sum))
        }
        return (hidden, output)
    }
    
    // passo reverso
    func backward(_ input: [Double], _ target: [Double]) {
        // Passo direto para obter valores ocultos e de saída
        let (hidden, output) = forward(input)
        let hiddenSlice = Array(hidden[0..<hiddenSize])
        
        // Calcula erros da camada de saída
        var outputErrors: [Double] = []
        for i in 0..<outputSize {
            let error = output[i] * (1 - output[i]) * (target[i] - output[i])
            outputErrors.append(error)
        }
        
        // Calcula erros de camada oculta
        var hiddenErrors: [Double] = []
        for i in 0..<hiddenSize {
            var error = 0.0
            for j in 0..<outputSize {
                error += outputErrors[j] * weights2[j][i]
            }
            error *= hidden[i] * (1 - hidden[i])
            hiddenErrors.append(error)
        }
        
        // Atualiza os pesos e vieses da camada de saída
        for i in 0..<outputSize {
            for j in 0..<hiddenSize {
                weights2[i][j] += learningRate * outputErrors[i] * hidden[j]
            }
            biases2[i] += learningRate * outputErrors[i]
        }

        // Atualiza os pesos e vieses da camada oculta
        for i in 0..<hiddenSize {
            for j in 0..<inputSize {
                weights1[i][j] += learningRate * hiddenErrors[i] * input[j]
            }
            biases1[i] += learningRate * hiddenErrors[i]
        }
    }

    // Treina o modelo em um conjunto de dados
    func train(_ inputs: [[Double]], _ targets: [[Double]], epochs: Int) {
        for epoch in 0..<epochs {
            for i in 0..<inputs.count {
                backward(inputs[i], targets[i])
            }
            print("Epoch \(epoch+1) complete")
        }
    }
}

let mlp = MLP(inputSize: 2, hiddenSize: 5, outputSize: 1, learningRate: 0.1)
let inputs: [[Double]] = [[0, 0], [0, 1], [1, 0], [1, 1]]
let targets: [[Double]] = [[0], [1], [1], [0]]
mlp.train(inputs, targets, epochs: 1000)

// Testa o modelo em novas entradas
let testInputs: [[Double]] = [[0, 0], [0, 1], [1, 0], [1, 1]]
for input in testInputs {
    let output = mlp.forward(input).0
    print("\(input[0]), \(input[1]) -> \(output)")
}
