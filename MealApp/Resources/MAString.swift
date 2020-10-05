// swiftlint:disable nesting
import Foundation

struct MAString {
    struct Scenes {
        struct Categories {
            static let title = String.localized(by: "scenes_categories_title")
            static let mealCellSubtitle = String.localized(by: "scenes_categories_cell_subtitle")

            private init() {}
        }

        struct Filter {
            static let title = String.localized(by: "scenes_filter_title")
            static let byArea = String.localized(by: "scenes_filter_by_area")
            static let byIngredient = String.localized(by: "scenes_filter_by_ingredient")

            private init() {}
        }

        private init() {}
    }

    struct Errors {
        static let generic = String.localized(by: "errors_generic")
        static let noConnection = String.localized(by: "errors_no_connection")

        private init() {}
    }

    struct General {
        static let loading = String.localized(by: "general_loading")
        static let tryAgain = String.localized(by: "general_try_again")

        private init() {}
    }

    private init() {}
}
