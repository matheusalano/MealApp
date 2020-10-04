import Foundation
import RxSwift

protocol MAFilterServiceProtocol {
    func getAreas() -> Single<MAFilterResponse>
    func getIngredients() -> Single<MAFilterResponse>
}

final class MAFilterService: MAFilterServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }

    func getAreas() -> Single<MAFilterResponse> {
        return service.request(path: .list, method: .GET, queryItems: [.init(name: "a", value: "list")], body: nil)
    }

    func getIngredients() -> Single<MAFilterResponse> {
        return service.request(path: .list, method: .GET, queryItems: [.init(name: "i", value: "list")], body: nil)
    }
}
