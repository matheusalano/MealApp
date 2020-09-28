import Foundation
import RxSwift

protocol MACategoriesServiceProtocol {
    func getCategories() -> Single<MACategoriesResponse>
    func getRandomMeal() -> Single<MACategoriesMealResponse>
}

final class MACategoriesService: MACategoriesServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }

    func getCategories() -> Single<MACategoriesResponse> {
        return service.request(path: .categories, method: .GET, queryItems: nil, body: nil)
    }

    func getRandomMeal() -> Single<MACategoriesMealResponse> {
        return service.request(path: .random, method: .GET, queryItems: nil, body: nil)
    }
}
