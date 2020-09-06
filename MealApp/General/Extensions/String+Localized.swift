import Foundation

extension String {
    static func localized(by key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
