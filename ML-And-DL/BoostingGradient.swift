import Foundation

// Definir a função de perda
func loss(yTrue: [Double], yPred: [Double]) -> Double {
  var error = 0.0
  for i in 0..<yTrue.count {
    error += pow(yTrue[i] - yPred[i], 2)
  }
  return error / Double(yTrue.count)
}

// Definir o modelo de base
class BaseModel {
  var weights: [Double]
  
  init() {
    self.weights = [Double]()
  }
  
  func predict(inputs: [Double]) -> Double {
    var output = 0.0
    for i in 0..<inputs.count {
      output += inputs[i] * self.weights[i]
    }
    return output
  }
  
  func train(inputs: [[Double]], targets: [Double], learningRate: Double, epochs: Int) {
    for _ in 0..<epochs {
      for i in 0..<inputs.count {
        let prediction = predict(inputs: inputs[i])
        let error = prediction - targets[i]
        for j in 0..<self.weights.count {
          self.weights[j] -= learningRate * error * inputs[i][j]
        }
      }
    }
  }
}

// Definir o modelo de boosting
class BoostedModel {
  var models: [BaseModel]
  var weights: [Double]
  
  init() {
    self.models = [BaseModel]()
    self.weights = [Double]()
  }
  
  func predict(inputs: [Double]) -> Double {
    var output = 0.0
    for i in 0..<self.models.count {
      output += self.weights[i] * self.models[i].predict(inputs: inputs)
    }
    return output
  }
  
  func train(inputs: [[Double]], targets: [Double], learningRate: Double, epochs: Int, numModels: Int) {
    for _ in 0..<numModels {
      let model = BaseModel()
      model.train(inputs: inputs, targets: targets, learningRate: learningRate, epochs: epochs)
      let predictions = inputs.map { model.predict(inputs: $0) }
      let residuals = zip(predictions, targets).map { $0 - $1 }
      let loss = zip(predictions, targets).map { pow($0 - $1, 2) }.reduce(0.0, +)
      let weight = 0.5 * log((1 - loss) / loss)
      self.models.append(model)
      self.weights.append(weight)
      for i in 0..<inputs.count {
        var targetsCopy = targets
        targetsCopy[i] = targetsCopy[i] - (2 * weight * residuals[i])
      }
    }
  }
}

// Create example data
let inputs: [[Double]] = [[1.0, 2.0], [2.0, 3.0], [3.0, 4.0], [4.0, 5.0]]
let targets: [Double] = [3.0, 5.0, 7.0, 9.0]

// Create a BoostedModel instance
let boostedModel = BoostedModel()

// Train the boosted model
boostedModel.train(inputs: inputs, targets: targets, learningRate: 0.1, epochs: 100, numModels: 3)

// Test the trained model
let testInputs: [[Double]] = [[5.0, 6.0], [6.0, 7.0]]
for input in testInputs {
    let prediction = boostedModel.predict(inputs: input)
    print("Input: \(input), Prediction: \(prediction)")
}
