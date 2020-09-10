import Foundation

struct MACategory: Decodable, Equatable, Identifiable {
    let id: String
    let name: String
    let thumbURL: String
    let description: String

    private enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbURL = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
