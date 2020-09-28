// swiftlint:disable force_unwrapping

import Foundation

@testable import MealApp

extension MACategory {
    static let dummy = MACategory(
        id: "1",
        name: "test_name",
        thumbURL: URL(string: "test_thumb")!,
        description: "test_desc"
    )

    static let dummy2 = MACategory(
        id: "2",
        name: "test_2",
        thumbURL: URL(string: "test_thumb")!,
        description: "test_desc"
    )

    static let dummy3 = MACategory(
        id: "3",
        name: "test_3",
        thumbURL: URL(string: "test_thumb")!,
        description: "test_desc"
    )
}

extension MACategoriesResponse {
    static let dummy = MACategoriesResponse(categories: [.dummy])
    static let dummyVC = MACategoriesResponse(categories: [.dummy, .dummy2, .dummy3])
}
