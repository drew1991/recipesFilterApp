

import SwiftUI

struct RemoteImageOfMeal: View {
    var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                ProgressView()
            }
        }
        .frame(width: 80, height: 80)
        .cornerRadius(8)
    }
}



struct RemoteImageOfMeal_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageOfMeal(url: Meal.example.thumbnailURL!)
    }
}
