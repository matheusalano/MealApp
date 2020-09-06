import Foundation
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    override func start() -> Observable<Void> {
        let categoriesCoordinator = MACategoriesCoordinator(navigator: navigator)
        let filterCoordinator = MAFilterCoordinator(navigator: navigator)

        return Observable.merge(
            coordinate(to: categoriesCoordinator),
            coordinate(to: filterCoordinator)
        )
    }
}
