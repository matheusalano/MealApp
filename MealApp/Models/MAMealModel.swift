import Foundation

struct MAMeal: Decodable, Equatable, Identifiable {
    struct Ingredient: Decodable, Equatable {
        let name: String
        let measure: String
    }

    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let thumbURL: URL
    let ingredients: [Ingredient]
}

extension MAMeal {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbURL = "strMealThumb"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        category = try values.decode(String.self, forKey: .category)
        area = try values.decode(String.self, forKey: .area)
        instructions = try values.decode(String.self, forKey: .instructions)
        thumbURL = try values.decode(URL.self, forKey: .thumbURL)

        guard let dict = try? decoder.singleValueContainer().decode([String: String?].self) else {
            ingredients = []
            return
        }

        var tempIngredients: [Ingredient] = []
        for i in 1 ... 20 {
            guard
                case let name?? = dict["strIngredient\(i)"],
                case let measure?? = dict["strMeasure\(i)"],
                !name.isEmpty && !measure.isEmpty
            else {
                break
            }
            tempIngredients.append(Ingredient(name: name, measure: measure.trimmingCharacters(in: .whitespaces)))
        }

        ingredients = tempIngredients
    }
}
