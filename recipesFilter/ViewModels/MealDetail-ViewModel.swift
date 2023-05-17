import SwiftUI

extension ViewDetailOfMeal {
    class ViewModel: ObservableObject {
        private let meal: Meal
        private let apiClient: APIClient
        
        @Published var instructions: String = ""
        @Published var ingredients: [Ingredient] = []
        
        init(meal: Meal, apiClient: APIClient = APIClient.shared) {
            self.meal = meal
            self.apiClient = apiClient
        }
        
        func fetchMealDetails() {
            apiClient.fetchMealDetails(mealID: meal.id) { [weak self] result in
                switch result {
                case .success(let details):
                    self?.updateDetails(with: details)
                case .failure(let error):
                    print("Error fetching meal details: \(error.localizedDescription)")
                }
            }
        }
        
        private func updateDetails(with details: MealDetailsResponse) {
            self.instructions = details.instructions
            self.ingredients = createIngredients(from: details)
        }
        
        private func createIngredients(from details: MealDetailsResponse) -> [Ingredient] {
            let ingredientKeys = Mirror(reflecting: details).children.compactMap { $0.label }
            let ingredients = ingredientKeys.compactMap { key -> Ingredient? in
                guard let value = details[key] as? String else { return nil }
                return Ingredient(name: value, quantity: details[key.replacingOccurrences(of: "strIngredient", with: "strMeasure")])
            }
            return ingredients.filter { !$0.name.isTrimmedEmpty() && !$0.quantity.isTrimmedEmpty() }
        }
    }
}
