import Foundation

struct NutritionResponse: Codable {
    let uri: String
    let calories: Double
    let totalCO2Emissions: Double
    let co2EmissionsClass: String
    let totalWeight: Double
    let dietLabels, healthLabels, cautions: [String]
    let totalNutrients, totalDaily: [String: TotalNutrient]
    let ingredients: [Ingredient]
    let totalNutrientsKCal: TotalNutrientsKCal
}

struct Ingredient: Codable {
    let text: String
    let parsed: [Parsed]
}

struct Parsed: Codable {
    let quantity: Double
    let measure, foodMatch, food: String
    let foodID: String
    let weight, retainedWeight: Double
    let nutrients: [String: TotalNutrient]
    let measureURI: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case quantity, measure, foodMatch, food
        case foodID = "foodId" // Mapear foodId para foodID
        case weight, retainedWeight, nutrients, measureURI, status
    }
}

struct TotalNutrient: Codable {
    let label: String
    let quantity: Double
    let unit: String
}

struct TotalNutrientsKCal: Codable {
    let enercKcal, procntKcal, fatKcal, chocdfKcal: TotalNutrient

    enum CodingKeys: String, CodingKey {
        case enercKcal = "ENERC_KCAL"
        case procntKcal = "PROCNT_KCAL"
        case fatKcal = "FAT_KCAL"
        case chocdfKcal = "CHOCDF_KCAL"
    }
}

struct NutritionResponseCode: Codable {
    let statusCode: Int
    let message: String
}

