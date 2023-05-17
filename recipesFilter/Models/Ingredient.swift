

import Foundation

struct Ingredient: Codable, Comparable {
    let name: String
    let quantity: String
    
    static func <(lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name < rhs.name
    }
}

extension Ingredient: Identifiable {
    var id: UUID { UUID() }
}
