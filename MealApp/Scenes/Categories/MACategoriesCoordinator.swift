import RxSwift
import UIKit

final class MACategoriesCoordinator: BaseCoordinator<Void> {
    let viewModel: MACategoriesViewModelProtocol

    override init(navigator: AppNavigator) {
        viewModel = MACategoriesViewModel()
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MACategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MACategoriesViewController(viewModel: viewModel)

        viewModel.navigationTarget
            .drive(onNext: { target in
                switch target {
                case .settings:
                    //TODO: Go to Settings
                    break
                }
            })
            .disposed(by: disposeBag)

        navigator.addTabViewController(viewController: viewController, visible: true)
        return Observable.never()
    }
}

extension MACategoriesCoordinator {
    enum Target: Equatable {
        case settings
    }
}
