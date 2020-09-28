import Foundation

struct MACategory: Decodable, Equatable, Identifiable {
    let id: String
    let name: String
    let thumbURL: URL
    let description: String
}

extension MACategory {
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbURL = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
