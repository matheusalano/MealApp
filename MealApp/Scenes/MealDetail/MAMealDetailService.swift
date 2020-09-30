import Foundation
import RxSwift

protocol MAMealDetailServiceProtocol {
    func getMeal(from id: String) -> Single<MAMealDetailResponse>
}

final class MAMealDetailService: MAMealDetailServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }

    func getMeal(from id: String) -> Single<MAMealDetailResponse> {
        service.request(path: .lookup, method: .GET, queryItems: [.init(name: "i", value: id)], body: nil)
    }
}
