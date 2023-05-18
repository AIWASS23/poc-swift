import Foundation
import Accelerate

func sigmoid(_ x: Float) -> Float {
    return 1 / (1 + exp(-x))
}

func sigmoidVector(_ vector: inout [Float]) {
    for i in 0..<vector.count {
        vector[i] = sigmoid(vector[i])
    }
}

func sigmoidMatrix(_ matrix: inout [[Float]]) {
    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            matrix[i][j] = sigmoid(matrix[i][j])
        }
    }
}

struct SimpleRNN {
    let inputSize: Int
    let hiddenSize: Int
    let outputSize: Int
    var weightIH: [Float]
    var weightHH: [Float]
    var weightHO: [Float]
    var hiddenState: [Float]

    init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        self.inputSize = inputSize
        self.hiddenSize = hiddenSize
        self.outputSize = outputSize
        self.weightIH = [Float](repeating: 0, count: inputSize * hiddenSize)
        self.weightHH = [Float](repeating: 0, count: hiddenSize * hiddenSize)
        self.weightHO = [Float](repeating: 0, count: hiddenSize * outputSize)
        self.hiddenState = [Float](repeating: 0, count: hiddenSize)

        // Inicialização aleatória dos pesos
        for i in 0..<weightIH.count {
            weightIH[i] = Float.random(in: -1...1)
        }

        for i in 0..<weightHH.count {
            weightHH[i] = Float.random(in: -1...1)
        }

        for i in 0..<weightHO.count {
            weightHO[i] = Float.random(in: -1...1)
        }
    }

    mutating func step(_ input: [Float]) -> [Float] {
        // Cálculo do novo estado oculto
        var newHiddenState = [Float](repeating: 0, count: hiddenSize)
        vDSP_mmul(input, 1, weightIH, 1, &newHiddenState, 1, vDSP_Length(1), vDSP_Length(hiddenSize), vDSP_Length(inputSize))
        vDSP_mmul(hiddenState, 1, weightHH, 1, &newHiddenState, 1, vDSP_Length(1), vDSP_Length(hiddenSize), vDSP_Length(hiddenSize))
        vDSP_vadd(newHiddenState, 1, hiddenState, 1, &newHiddenState, 1, vDSP_Length(hiddenSize))
        sigmoidVector(&newHiddenState)

        // Cálculo da saída
        var output = [Float](repeating: 0, count: outputSize)
        vDSP_mmul(newHiddenState, 1, weightHO, 1, &output, 1, vDSP_Length(1), vDSP_Length(outputSize), vDSP_Length(hiddenSize))
        sigmoidVector(&output)

        hiddenState = newHiddenState

        return output
    }
}

// Exemplo de uso
let inputSize = 3
let hiddenSize = 4
let outputSize = 2

var rnn = SimpleRNN(inputSize: inputSize, hiddenSize: hiddenSize, outputSize: outputSize)

let input = [Float](repeating: 0.5, count: inputSize) // Entrada com 3 recursos
let output = rnn.step(input)
print(output)
