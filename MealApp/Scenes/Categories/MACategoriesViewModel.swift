import Foundation
import RxCocoa
import RxSwift

protocol MACategoriesViewModelProtocol {
    typealias Target = MACategoriesCoordinator.Target

    var didTapLeftBarButton: PublishSubject<Void> { get }

    var navigationTarget: Driver<Target> { get }
}

final class MACategoriesViewModel: MACategoriesViewModelProtocol {
    //MARK: Inputs

    let didTapLeftBarButton = PublishSubject<Void>()

    //MARK: Outputs

    let navigationTarget: Driver<Target>

    init() {
        navigationTarget = Observable.merge(
            didTapLeftBarButton.map({ .settings })
        ).asDriver(onErrorRecover: { _ in .empty() })
    }
}
