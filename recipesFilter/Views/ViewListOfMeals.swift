
import SwiftUI
struct ViewListOfMeals: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.meals, id: \.id) { meal in
                    NavigationLink(destination: ViewDetailOfMeal(meal: meal)) {
                        HStack(spacing: 16) {
                            RemoteImageOfMeal(url: meal.thumbnailURL ?? "")
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(meal.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Tap to view details")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("\(viewModel.category.rawValue) Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    viewModel.changingCategory = true
                }) {
                    Image(systemName: "arrow.triangle.swap")
                        .imageScale(.large)
                }
            }
            .task {
                await viewModel.fetchMealCategory()
            }
        }
        .onChange(of: viewModel.category) { _ in
            Task {
                await viewModel.fetchMealCategory()
            }
        }
        .sheet(isPresented: $viewModel.changingCategory) {
            ChangeCategoryForm(category: $viewModel.category, isPresented: $viewModel.changingCategory)
        }
    }
}


struct ViewListOfMeals_Previews: PreviewProvider {
    static var previews: some View {
        ViewListOfMeals()
    }
}


struct ChangeCategoryForm: View {
    @Binding var category: MealCategory
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Category")) {
                    Picker(selection: $category, label: Text("")) {
                        ForEach(MealCategory.allCases, id: \.rawValue) { category in
                            Text(category.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Change Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Text("Cancel")
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Text("Done")
                            .fontWeight(.bold)
                    })
                }
            }
        }
    }
}
