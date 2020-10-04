import RxDataSources

struct MAFilterResponse: Decodable, Equatable {
    struct Item: Decodable, Equatable {
        let value: String

        init(value: String) {
            self.value = value
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.singleValueContainer().decode([String: String?].self)
            if case let ingredient?? = values["strIngredient"] {
                value = ingredient
            } else if case let area?? = values["strArea"] {
                value = area
            } else {
                throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: ""))
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case list = "meals"
    }

    let list: [Item]
}

struct MAFilterCellModel: Equatable {
    let title: String
    let systemImage: String
    let selected: Bool
}

enum MAFilterSectionModel: Equatable {
    case filterSection(items: [MAFilterSectionItem])
    case optionSection(items: [MAFilterSectionItem])
}

enum MAFilterSectionItem: Equatable {
    case filterOption(MAFilterCellModel)
    case option(String)
}

extension MAFilterSectionModel: SectionModelType {
    typealias Item = MAFilterSectionItem

    var items: [MAFilterSectionItem] {
        switch self {
        case let .filterSection(items: items):
            return items
        case let .optionSection(items: items):
            return items
        }
    }

    init(original: MAFilterSectionModel, items: [Item]) {
        switch original {
        case .filterSection(items: _):
            self = .filterSection(items: items)
        case .optionSection(items: _):
            self = .optionSection(items: items)
        }
    }
}
