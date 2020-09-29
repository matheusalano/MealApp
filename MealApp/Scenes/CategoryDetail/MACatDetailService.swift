import Foundation
import RxSwift

protocol MACatDetailServiceProtocol {
    func getMeals(from categoryName: String) -> Single<MACatDetailResponse>
}

final class MACatDetailService: MACatDetailServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }

    func getMeals(from categoryName: String) -> Single<MACatDetailResponse> {
        return service.request(path: .filter, method: .GET, queryItems: [.init(name: "c", value: categoryName)], body: nil)
    }
}
