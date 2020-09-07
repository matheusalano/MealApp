import Foundation
import RxCocoa
import RxSwift

protocol MAFilterViewModelProtocol {
    typealias Target = MAFilterCoordinator.Target

    var didTapLeftBarButton: PublishSubject<Void> { get }

    var navigationTarget: Driver<Target> { get }
}

final class MAFilterViewModel: MAFilterViewModelProtocol {
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
