// swiftlint:disable force_unwrapping

import Foundation

@testable import MealApp

extension MAMealBasic {
    static let dummy = MAMealBasic(
        id: "123",
        name: "test_name",
        thumbURL: URL(string: "test_thumb")!
    )
}

extension MAMeal {
    static let dummy = MAMeal(
        id: "123",
        name: "test_name",
        category: "test_cat",
        area: "test_area",
        instructions: "test_inst",
        thumbURL: URL(string: "test_thumb")!,
        ingredients: []
    )
}

extension MACategoriesMealResponse {
    static let dummy = MACategoriesMealResponse(meals: [.dummy])
}

extension MACatDetailResponse {
    static let dummy = MACatDetailResponse(meals: [.dummy])
}

extension MAMealDetailResponse {
    static let dummy = MAMealDetailResponse(meals: [.dummy])
}
