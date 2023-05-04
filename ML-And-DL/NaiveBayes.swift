import Foundation

extension String: Error {}

extension Array where Element == Double { // funciona apenas para arrays que contém elementos do tipo Double. 

    func mean() -> Double {
        return self.reduce(0, +) / Double(count)

        /*
            calcula a média aritmética dos valores contidos no array. Ela faz isso somando todos os 
            elementos do array e dividindo o resultado pelo número de elementos do array.
        */
    }

    func standardDeviation() -> Double {
        let calculatedMean = mean()

        let sum = self.reduce(0.0) { (previous, next) in
            return previous + pow(next - calculatedMean, 2)
        }

        return sqrt(sum / Double(count - 1))

        /*
            calcula o desvio padrão dos valores contidos no array. Ela faz isso primeiro calculando a média 
            aritmética dos valores do array usando a função mean(). Em seguida, ela calcula a soma dos 
            quadrados das diferenças entre cada valor do array e a média aritmética. Finalmente, ela divide 
            essa soma pelo número de elementos do array menos um e tira a raiz quadrada desse resultado para 
            obter o desvio padrão.
        */
    }
}

extension Array where Element == Int { // funciona apenas para arrays que contém elementos do tipo Int.

    func uniques() -> Set<Element> {
        return Set(self)

        /*
            essa função retorna um conjunto (Set) contendo apenas os elementos únicos do array. Ela faz isso 
            criando um novo conjunto a partir do array, o que remove automaticamente qualquer elemento 
            duplicado.
        */
    }

}

enum NBType {

    case gaussian
    case multinomial
    case bernoulli

    func calcLikelihood(variables: [Any], input: Any) -> Double? {

        if case .gaussian = self {

            guard let input = input as? Double else {
                return nil
            }

            guard let mean = variables[0] as? Double else {
                return nil
            }

            guard let stDev = variables[1] as? Double else {
                return nil
            }

            let eulerPart = pow(M_E, -1 * pow(input - mean, 2) / (2 * pow(stDev, 2)))
            let distribution = eulerPart / sqrt(2 * .pi) / stDev

            return distribution

        } else if case .multinomial = self {

            guard let variables = variables as? [(category: Int, probability: Double)] else {
                return nil
            }

            guard let input = input as? Int else {
                return nil
            }

            return variables.first { variable in
                return variable.category == input
                }?.probability

        } else if case .bernoulli = self {
            
            guard let variables = variables as? [(category: Int, probability: Double)] else {
                return nil
            }

            guard let input = input as? Bool else {
                return nil
            }

            let probability = variables.first { variable in
                return variable.category == (input ? 1 : 0)
            }?.probability ?? 0.0

            return probability

        }
        
        return nil

        /*
            calcula a probabilidade da entrada input dada as variáveis aprendidas pelo modelo. O tipo de 
            modelo é inferido pelo caso em que a enum está. Para cada tipo de modelo, a função calcula a 
            probabilidade de maneira diferente.
        */
    }

    func train(values: [Any]) -> [Any]? {

        if case .gaussian = self {

            guard let values = values as? [Double] else {
                return nil
            }

            return [values.mean(), values.standardDeviation()]

        } else if case .multinomial = self {

            guard let values = values as? [Int] else {
                return nil
            }

            let count = values.count
            let categoryProba = values.uniques().map { value -> (Int, Double) in
                return (value, Double(values.filter { $0 == value }.count) / Double(count))
            }
            return categoryProba
            
        } else if case .bernoulli = self {
            
            guard let values = values as? [Bool] else {
                return nil
            }

            let count = values.count
            let categoryProba = [(0, 1.0 - Double(values.filter { $0 }.count) / Double(count)),
                                 (1, Double(values.filter { $0 }.count) / Double(count))]
            return categoryProba
        }

        return nil

        /*
            treina o modelo com base nos valores de entrada fornecidos. Ele calcula as variáveis necessárias 
            para cada tipo de modelo e retorna essas variáveis. Esse método só é aplicável a tipos de 
            modelos que requerem treinamento (ou seja, gaussian, multinomial e bernoulli).
        */
    }
}

class NaiveBayes<T> {

    var variables: [Int: [(feature: Int, variables: [Any])]]
    var type: NBType

    var data: [[T]]
    var classes: [Int]

    init(type: NBType, data: [[T]], classes: [Int]) throws {
        self.type = type
        self.data = data
        self.classes = classes
        self.variables = [Int: [(Int, [Any])]]()

        if case .gaussian = type, T.self != Double.self {
            throw "When using Gaussian NB you have to have continuous features (Double)"
        } else if case .multinomial = type, T.self != Int.self {
            throw "When using Multinomial NB you have to have categorical features (Int)"
        } else if case .bernoulli = type, T.self != Double.self {
            throw "When using Bernoulli NB you have to have continuous features (Double)"
        }
    }

    func train() throws -> Self {

        for `class` in classes.uniques() {
            variables[`class`] = [(Int, [Any])]()

            let classDependent = data.enumerated().filter { (offset, _) in
                return classes[offset] == `class`
            }

            for feature in 0..<data[0].count {

                let featureDependent = classDependent.map { $0.element[feature] }

                guard let trained = type.train(values: featureDependent) else {
                    throw "Critical! Data could not be casted even though it was checked at init"
                }

                variables[`class`]?.append((feature, trained))
            }
        }

        return self
    }

    func classify(with input: [T]) -> Int {
        let likelihoods = classifyProba(with: input).max { (first, second) -> Bool in
            return first.1 < second.1
        }

        guard let `class` = likelihoods?.0 else {
            return -1
        }

        return `class`
    }

    func classifyProba(with input: [T]) -> [(Int, Double)] {

        var probaClass = [Int: Double]()
        let amount = classes.count

        classes.forEach { `class` in
            let individual = classes.filter { $0 == `class` }.count
            probaClass[`class`] = Double(individual) / Double(amount)
        }

        let classesAndFeatures = variables.map { (`class`, value) -> (Int, [Double]) in
            let distribution = value.map { (feature, variables) -> Double in
                return type.calcLikelihood(variables: variables, input: input[feature]) ?? 0.0
            }
            return (`class`, distribution)
        }

        let likelihoods = classesAndFeatures.map { (`class`, distribution) in
            return (`class`, distribution.reduce(1, *) * (probaClass[`class`] ?? 0.0))
        }

        let sum = likelihoods.map { $0.1 }.reduce(0, +)
        let normalized = likelihoods.map { (`class`, likelihood) in
            return (`class`, likelihood / sum)
        }

        return normalized
    }
}
