import Foundation

struct MealDetailsResponse: Codable {
    let name: String
    let instructions: String
    let ingredients: [String]
    let measurements: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case instructions = "strInstructions"
        case ingredients = (1...20).map { "strIngredient\($0)" }
        case measurements = (1...20).map { "strMeasure\($0)" }
    }
}

struct MealDetailsResponseResult: Codable {
    let meals: [MealDetailsResponse]
}
