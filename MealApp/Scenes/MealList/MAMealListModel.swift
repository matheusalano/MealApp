import Foundation

struct MAMealListResponse: Decodable, Equatable {
    let meals: [MAMealBasic]
}

enum MAMealListFilter: String, Equatable {
    case area
    case ingredient
}
