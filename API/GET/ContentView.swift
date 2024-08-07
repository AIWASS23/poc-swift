import SwiftUI

struct ContentView: View {
    @State private var selectedNutritionType = "cooking"
    @State private var value = ""
    @State private var foodParam = ""
    @State private var selectedUnit = "g"
    @State private var nutritionResponse: NutritionResponse?
    @State private var errorMessage: String?
    
    let serviceApi = ServiceApi()
    let units = ["g", "t", "tb", "oz", "kg", "cups", "ml"]
    let nutritionType = ["cooking", "logging"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Nutrition Type", selection: $selectedNutritionType) {
                    ForEach(nutritionType, id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    TextField("Value", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.decimalPad)
                    
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                TextField("Food Parameter", text: $foodParam)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                Button(action: {
                    serviceApi.getNutritionAnalysisCompletion(nutritionType: selectedNutritionType, value: value, unit: selectedUnit, foodParam: foodParam) { (code, response, error) in
                        if let response = response {
                            self.nutritionResponse = response
                            self.errorMessage = nil
                        } else if let error = error {
                            self.errorMessage = error.localizedDescription
                            self.nutritionResponse = nil
                        } else if let code = code {
                            self.errorMessage = code.message
                            self.nutritionResponse = nil
                        }
                    }
                }) {
                    Text("Get Nutrition Analysis Completion")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    Task {
                        do {
                            let (responseCode, response) = try await serviceApi.getNutritionAnalysisAsync(
                                nutritionType: selectedNutritionType,
                                value: value,
                                unit: selectedUnit,
                                foodParam: foodParam
                            )
                            
                            // Tratar os resultados
                            if let response = response {
                                self.nutritionResponse = response
                                self.errorMessage = nil
                            } else if let code = responseCode {
                                self.errorMessage = code.message
                                self.nutritionResponse = nil
                            } else {
                                self.errorMessage = "Unknown error occurred"
                                self.nutritionResponse = nil
                            }
                        } catch {
                            // Tratar erros
                            self.errorMessage = error.localizedDescription
                            self.nutritionResponse = nil
                        }
                    }
                }) {
                    Text("Get Nutrition Analysis Async")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    serviceApi.getNutritionAnalysisAlamofire(nutritionType: selectedNutritionType, value: value, unit: selectedUnit, foodParam: foodParam) { (code, response, error) in
                        if let response = response {
                            self.nutritionResponse = response
                            self.errorMessage = nil
                        } else if let error = error {
                            self.errorMessage = error.localizedDescription
                            self.nutritionResponse = nil
                        } else if let code = code {
                            self.errorMessage = code.message
                            self.nutritionResponse = nil
                        }
                    }
                }) {
                    Text("Get Nutrition Analysis Alamofire")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    serviceApi.getNutritionAnalysisCombine(nutritionType: selectedNutritionType, value: value, unit: selectedUnit, foodParam: foodParam) { (code, response, error) in
                        if let response = response {
                            self.nutritionResponse = response
                            self.errorMessage = nil
                        } else if let error = error {
                            self.errorMessage = error.localizedDescription
                            self.nutritionResponse = nil
                        } else if let code = code {
                            self.errorMessage = code.message
                            self.nutritionResponse = nil
                        }
                    }
                }) {
                    Text("Get Nutrition Analysis Combine")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                
                
                if let response = nutritionResponse {
                    VStack(alignment: .leading) {
                        Text("Calories: \(response.calories)")
                        Text("Total Weight: \(response.totalWeight)")
                        Text("Diet Labels: \(response.dietLabels.joined(separator: ", "))")
                        Text("Health Labels: \(response.healthLabels.joined(separator: ", "))")
                    }
                    .padding()
                }
                
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Nutrition Analysis")
        }
    }
}

