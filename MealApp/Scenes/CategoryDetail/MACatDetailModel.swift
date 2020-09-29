import Foundation
import RxDataSources

struct MACatDetailResponse: Decodable, Equatable {
    let meals: [MAMealBasic]
}

enum MACatDetailSectionModel: Equatable {
    case mealSection(items: [MACatDetailSectionItem])
    case headerSection(items: [MACatDetailSectionItem])
}

enum MACatDetailSectionItem: Equatable {
    case meal(MAMealBasic)
    case header(MACategory)
}

extension MACatDetailSectionModel: SectionModelType {
    typealias Item = MACatDetailSectionItem

    var items: [MACatDetailSectionItem] {
        switch self {
        case let .mealSection(items: items):
            return items
        case let .headerSection(items: items):
            return items
        }
    }

    init(original: MACatDetailSectionModel, items: [Item]) {
        switch original {
        case .mealSection(items: _):
            self = .mealSection(items: items)
        case .headerSection(items: _):
            self = .headerSection(items: items)
        }
    }
}
