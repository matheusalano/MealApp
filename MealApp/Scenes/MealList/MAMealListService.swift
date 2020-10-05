import Foundation
import RxSwift

protocol MAMealListServiceProtocol {
    func getMeals(filteredBy filter: MAMealListFilter, value: String) -> Single<MAMealListResponse>
}

final class MAMealListService: MAMealListServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }

    func getMeals(filteredBy filter: MAMealListFilter, value: String) -> Single<MAMealListResponse> {
        let adaptedValue = value.replacingOccurrences(of: " ", with: "_")

        switch filter {
        case .area:
            return service.request(path: .filter, method: .GET, queryItems: [.init(name: "a", value: adaptedValue)], body: nil)
        case .ingredient:
            return service.request(path: .filter, method: .GET, queryItems: [.init(name: "i", value: adaptedValue)], body: nil)
        }
    }
}
