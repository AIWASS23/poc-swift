
import Foundation
import Accelerate

// Função de convolução
func convolve(input: [[Float]], filter: [[Float]], bias: Float) -> [[Float]] {
    let inputWidth = input[0].count
    let inputHeight = input.count
    let filterWidth = filter[0].count
    let filterHeight = filter.count
    
    let outputWidth = inputWidth - filterWidth + 1
    let outputHeight = inputHeight - filterHeight + 1
    
    var output = Array(repeating: Array(repeating: 0.0, count: outputWidth), count: outputHeight)
    
    for y in 0..<outputHeight {
        for x in 0..<outputWidth {
            var sum: Float = 0.0
            for filterY in 0..<filterHeight {
                for filterX in 0..<filterWidth {
                    sum += input[y + filterY][x + filterX] * filter[filterY][filterX]
                }
            }
            output[y][x] = Double(sum + bias)
        }
    }
    
    return output
}

// Função de pooling (max pooling)
func maxPool(input: [[Float]], poolSize: Int, strides: Int) -> [[Float]] {
    let inputWidth = input[0].count
    let inputHeight = input.count
    
    let outputWidth = (inputWidth - poolSize) / strides + 1
    let outputHeight = (inputHeight - poolSize) / strides + 1
    
    var output = Array(repeating: Array(repeating: 0.0, count: outputWidth), count: outputHeight)
    
    for y in 0..<outputHeight {
        for x in 0..<outputWidth {
            var maxVal: Float = -Float.greatestFiniteMagnitude
            for poolY in 0..<poolSize {
                for poolX in 0..<poolSize {
                    let value = input[y * strides + poolY][x * strides + poolX]
                    if value > maxVal {
                        maxVal = value
                    }
                }
            }
            output[y][x] = Double(maxVal)
        }
    }
    
    return output
}

// Função de ativação (ReLU)
func relu(input: [[Float]]) -> [[Float]] {
    var output = input
    for y in 0..<input.count {
        for x in 0..<input[0].count {
            output[y][x] = max(0.0, input[y][x])
        }
    }
    return output
}

// Função de achatamento
func flatten(input: [[Float]]) -> [Float] {
    return input.flatMap { $0 }
}

// Função de camada densa (fully connected)
func dense(input: [Float], weights: [[Float]], bias: [Float]) -> [Float] {
    let inputSize = input.count
    let outputSize = bias.count
    
    var output = Array(repeating: 0.0, count: outputSize)
    
    for i in 0..<outputSize {
        var sum: Float = 0.0
        for j in 0..<inputSize {
            sum += input[j] * weights[j][i]
        }
        output[i] = Double(sum + bias[i])
    }
    return output
}

// Implementação da CNN
func convolutionalNeuralNetwork(input: [[Float]]) -> [Float] {
    // Definindo os pesos e biases da rede
    let convFilter = [[1.0, 0.0, -1.0], [1.0, 0.0, -1.0], [1.0, 0.0, -1.0]]
    let convBias: Float = 0.0
    
    let poolSize = 2
    let poolStrides = 2
    
    let denseWeights = [[0.5, 0.3], [0.2, 0.4], [0.1, 0.7]]
    let denseBias = [0.1, 0.2]
    
    // Camada convolucional
    let convOutput = convolve(input: input, filter: convFilter, bias: convBias)
    let convActivated = relu(input: convOutput)
    
    // Camada de pooling
    let pooled = maxPool(input: convActivated, poolSize: poolSize, strides: poolStrides)
    
    // Achatamento
    let flattened = flatten(input: pooled)
    
    // Camada densa
    let denseOutput = dense(input: flattened, weights: denseWeights, bias: denseBias)
    
    return denseOutput
}

// Exemplo de uso da CNN
let input: [[Float]] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]

let output = convolutionalNeuralNetwork(input: input)
print(output)

    
