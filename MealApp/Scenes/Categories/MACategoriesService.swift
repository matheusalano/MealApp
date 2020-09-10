import Foundation
import RxSwift

struct MACategoriesResponse: Decodable, Equatable {
    let categories: [MACategory]
}

protocol MACategoriesServiceProtocol {
    func getCategories() -> Single<MACategoriesResponse>
}

final class MACategoriesService: MACategoriesServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }

    func getCategories() -> Single<MACategoriesResponse> {
        return service.request(path: .categories, method: .GET, queryItems: nil, body: nil)
    }
}
