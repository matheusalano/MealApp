// swiftlint:disable force_unwrapping

import Foundation

@testable import MealApp

extension MAMeal {
    static let dummy = MAMeal(
        idMeal: "123",
        strMeal: "test_name",
        strDrinkAlternate: nil,
        strCategory: "test_cat",
        strArea: "test_area",
        strInstructions: "test_instr",
        strMealThumb: URL(string: "test_thumb")!,
        strYoutube: nil,
        strIngredient1: nil,
        strIngredient2: nil,
        strIngredient3: nil,
        strIngredient4: nil,
        strIngredient5: nil,
        strIngredient6: nil,
        strIngredient7: nil,
        strIngredient8: nil,
        strIngredient9: nil,
        strIngredient10: nil,
        strIngredient11: nil,
        strIngredient12: nil,
        strIngredient13: nil,
        strIngredient14: nil,
        strIngredient15: nil,
        strIngredient16: nil,
        strIngredient17: nil,
        strIngredient18: nil,
        strIngredient19: nil,
        strIngredient20: nil,
        strMeasure1: nil,
        strMeasure2: nil,
        strMeasure3: nil,
        strMeasure4: nil,
        strMeasure5: nil,
        strMeasure6: nil,
        strMeasure7: nil,
        strMeasure8: nil,
        strMeasure9: nil,
        strMeasure10: nil,
        strMeasure11: nil,
        strMeasure12: nil,
        strMeasure13: nil,
        strMeasure14: nil,
        strMeasure15: nil,
        strMeasure16: nil,
        strMeasure17: nil,
        strMeasure18: nil,
        strMeasure19: nil,
        strMeasure20: nil,
        strSource: URL(string: "test_source")!
    )
}

extension MACategoriesMealResponse {
    static let dummy = MACategoriesMealResponse(meals: [.dummy])
}
