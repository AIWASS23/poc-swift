import Foundation

/*
    A função stochasticGradientDescent é definida com quatro parâmetros: x e y são os dados de 
    entrada e saída correspondentes, alpha é a taxa de aprendizado (learning rate) e 
    numIterations é o número de iterações para executar o algoritmo. 
    A função retorna um array de valores theta.
*/
func stochasticGradientDescent(x: [Double], y: [Double], alpha: Double, numIterations: Int) -> [Double] {
    var theta = Array(repeating: 0.0, count: x.count)
    
    for _ in 1...numIterations {
        let randomIndex = Int.random(in: 0..<x.count)
        let x_i = x[randomIndex]
        let y_i = y[randomIndex]
        
        let hypothesis = dot(theta, [1.0, x_i])
        let error = hypothesis - y_i
        
        theta[0] = theta[0] - alpha * error
        theta[1] = theta[1] - alpha * error * x_i
    }
    
    return theta
}

// Calcula o produto interno (também conhecido como produto escalar) de duas matrizes de números de ponto flutuante (double) a e b, representadas como vetores unidimensionais.
func dot(_ a: [Double], _ b: [Double]) -> Double {
    return zip(a, b).map(*).reduce(0, +)
}

let x = [1.0, 2.0, 3.0, 4.0, 5.0]
let y = [2.0, 4.0, 6.0, 8.0, 10.0]

let alpha = 0.01
let numIterations = 1000

let theta = stochasticGradientDescent(x: x, y: y, alpha: alpha, numIterations: numIterations)

print("Theta: \(theta)")