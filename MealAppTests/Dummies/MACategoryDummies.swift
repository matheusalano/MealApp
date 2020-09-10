import Foundation

@testable import MealApp

extension MACategory {
    static let dummy = MACategory(
        id: "1",
        name: "test_name",
        thumbURL: "test_thumb",
        description: "test_desc"
    )
}

extension MACategoriesResponse {
    static let dummy = MACategoriesResponse(categories: [.dummy])
}
