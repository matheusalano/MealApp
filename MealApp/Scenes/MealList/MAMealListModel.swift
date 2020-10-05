import Foundation

struct MAMealListResponse: Decodable, Equatable {
    let meals: [MAMealBasic]
}

enum MAMealListFilter: Equatable {
    case area
    case ingredient
}
