import Foundation

struct Example {
    let attributes: [String: String]
    let classLabel: String
}

class TreeNode {
    var attribute: String?
    var classLabel: String?
    var branches: [String: TreeNode]?
}

//class TreeNode {
//    var attribute: String!
//    var classLabel: String!
//    var branches: [String: TreeNode]!
//}

//public class TreeNode<T> {
//    public var value: T
//
//    public weak var parent: TreeNode?
//    public var children = [TreeNode<T>]()
//
//    public init(value: T) {
//        self.value = value
//    }
//
//    public func addChild(_ node: TreeNode<T>) {
//        children.append(node)
//        node.parent = self
//    }
//}

func createDecisionTree(trainingData: [Example], attributes: [String]) -> TreeNode {
    let root = trainHelper(trainingData: trainingData, attributes: attributes)
    return root
}

func trainHelper(trainingData: [Example], attributes: [String]) -> TreeNode {
    let node = TreeNode()
    
    // caso 1: todos os exemplos têm a mesma classe
    let classes = Set(trainingData.map { $0.classLabel })
    if classes.count == 1 {
        node.classLabel = classes.first
        return node
    }
    
    // caso 2: não há mais atributos para dividir
    if attributes.count == 0 {
        let classCounts = Dictionary(grouping: trainingData, by: { $0.classLabel })
            .mapValues { $0.count }
        let mostCommonClass = classCounts.max { $0.value < $1.value }!.key
        node.classLabel = mostCommonClass
        return node
    }
    
    // caso 3: escolhe o melhor atributo para dividir os exemplos
    let (bestAttribute, bestGain) = chooseBestAttribute(trainingData: trainingData, attributes: attributes)
    node.attribute = bestAttribute
    
    // caso 4: cria ramos para cada valor do melhor atributo
    var branches = [String: TreeNode]()
    for attributeValue in Set(trainingData.map { $0.attributes[bestAttribute]! }) {
        let examplesWithAttributeValue = trainingData.filter { $0.attributes[bestAttribute] == attributeValue }
        let remainingAttributes = attributes.filter { $0 != bestAttribute }
        let subtree = trainHelper(trainingData: examplesWithAttributeValue, attributes: remainingAttributes)
        branches[attributeValue] = subtree
    }
    node.branches = branches
    
    return node
}

func chooseBestAttribute(trainingData: [Example], attributes: [String]) -> (String, Double) {
    let classCounts = Dictionary(grouping: trainingData, by: { $0.classLabel })
        .mapValues { $0.count }
    let totalExamples = Double(trainingData.count)
    let baseEntropy = entropy(probabilities: classCounts.mapValues { Double($0) / totalExamples })
    
    var bestAttribute = ""
    var bestGain = 0.0
    
    for attribute in attributes {
        let attributeValues = Set(trainingData.map { $0.attributes[attribute]! })
        var attributeEntropy = 0.0
        
        for attributeValue in attributeValues {
            let examplesWithAttributeValue = trainingData.filter { $0.attributes[attribute] == attributeValue }
            let classCounts = Dictionary(grouping: examplesWithAttributeValue, by: { $0.classLabel })
                .mapValues { $0.count }
            let totalExamplesWithAttributeValue = Double(examplesWithAttributeValue.count)
            let probability = totalExamplesWithAttributeValue / totalExamples
            attributeEntropy += probability * entropy(probabilities: classCounts.mapValues { Double($0) / totalExamplesWithAttributeValue })
        }
        
        let informationGain = baseEntropy - attributeEntropy
        if informationGain > bestGain {
            bestAttribute = attribute
            bestGain = informationGain
        }
    }
    
    return (bestAttribute, bestGain)
}

func entropy(probabilities: [String: Double]) -> Double {
    return probabilities.values.map { -$0 * log2($0) }.reduce(0, +)
}

func predict(example: Example, decisionTree: TreeNode) -> String {
    if let classLabel = decisionTree.classLabel {
        return classLabel
    }
    
    let attribute = decisionTree.attribute!
    let attributeValue = example.attributes[attribute]!
    let branch = decisionTree.branches![attributeValue]! // resolver em casa

    return predict(example: example, decisionTree: branch)
}

let irisData = [
    Example(attributes: ["sepal length": "5.1", "sepal width": "3.5", "petal length": "1.4", "petal width": "0.2"], classLabel: "Iris-setosa"),
    Example(attributes: ["sepal length": "4.9", "sepal width": "3.0", "petal length": "1.4", "petal width": "0.2"], classLabel: "Iris-setosa"),
    Example(attributes: ["sepal length": "7.0", "sepal width": "3.2", "petal length": "4.7", "petal width": "1.4"], classLabel: "Iris-versicolor"),
    Example(attributes: ["sepal length": "6.4", "sepal width": "3.2", "petal length": "4.5", "petal width": "1.5"], classLabel: "Iris-versicolor"),
    Example(attributes: ["sepal length": "6.3", "sepal width": "3.3", "petal length": "6.0", "petal width": "2.5"], classLabel: "Iris-virginica"),
    Example(attributes: ["sepal length": "5.8", "sepal width": "2.7", "petal length": "5.1", "petal width": "1.9"], classLabel: "Iris-virginica")
]

let attributes = ["sepal length", "sepal width", "petal length", "petal width"]
let decisionTree = createDecisionTree(trainingData: irisData, attributes: attributes)

let example1 = Example(attributes: ["sepal length": "5.0", "sepal width": "3.5", "petal length": "1.3", "petal width": "0.3"], classLabel: "")
let example2 = Example(attributes: ["sepal length": "6.5", "sepal width": "3.0", "petal length": "5.5", "petal width": "1.8"], classLabel: "")

let prediction1 = predict(example: example1, decisionTree: decisionTree)
let prediction2 = predict(example: example2, decisionTree: decisionTree)

print("Prediction for example 1: \(prediction1)")
print("Prediction for example 2: \(prediction2)")


