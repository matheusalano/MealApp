import Foundation

@testable import MealApp

enum ResultType {
    case success
    case failure(error: ServiceError)
}
