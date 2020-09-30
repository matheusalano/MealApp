import Foundation
import RxSwift

protocol MAMealDetailServiceProtocol {}

final class MAMealDetailService: MAMealDetailServiceProtocol {
    let service: AppServiceProtocol

    init(service: AppServiceProtocol = AppService()) {
        self.service = service
    }
}
