

import SwiftUI
struct ViewDetailOfMeal: View {
    var meal: Meal
    
    @StateObject private var viewModel: ViewModel
    
    init(meal: Meal) {
        self.meal = meal
        _viewModel = StateObject(wrappedValue: ViewModel(meal: meal))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteImageOfMeal(url: meal.thumbnailURL ?? "")
                    .frame(height: 200)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ForEach(viewModel.ingredients) { ingredient in
                        Text("\(ingredient.name) - \(ingredient.quantity)")
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(viewModel.instructions)
                }
                .padding(.horizontal)
            }
            .task {
                await viewModel.fetchMealDetails()
            }
            .padding()
        }
        .navigationTitle(meal.name)
    }
}


struct ViewDetailOfMeal_Previews: PreviewProvider {
    static var previews: some View {
        ViewDetailOfMeal(meal: Meal.example)
    }
}
