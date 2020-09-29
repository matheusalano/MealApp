import Foundation
import RxDataSources

struct MACategoriesResponse: Decodable, Equatable {
    let categories: [MACategory]
}

struct MACategoriesMealResponse: Decodable, Equatable {
    let meals: [MAMealBasic]
}

enum MACategorySectionModel: Equatable {
    case mealSection(items: [MACategorySectionItem])
    case categorySection(items: [MACategorySectionItem])
}

enum MACategorySectionItem: Equatable {
    case meal(MAMealBasic)
    case category(MACategory)
}

extension MACategorySectionModel: SectionModelType {
    typealias Item = MACategorySectionItem

    var items: [MACategorySectionItem] {
        switch self {
        case let .mealSection(items: items):
            return items
        case let .categorySection(items: items):
            return items
        }
    }

    init(original: MACategorySectionModel, items: [Item]) {
        switch original {
        case .mealSection(items: _):
            self = .mealSection(items: items)
        case .categorySection(items: _):
            self = .categorySection(items: items)
        }
    }
}
