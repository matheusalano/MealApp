import RxSwift
import UIKit

final class MAFilterCoordinator: BaseCoordinator<Void> {
    let viewModel: MAFilterViewModelProtocol

    override init(navigator: AppNavigator) {
        viewModel = MAFilterViewModel()
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MAFilterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MAFilterViewController(viewModel: viewModel)

        viewModel.navigationTarget
            .drive(onNext: { target in
                switch target {
                case .settings:
                    //TODO: Go to Settings
                    break
                }
            })
            .disposed(by: disposeBag)

        navigator.addTabViewController(viewController: viewController, visible: false)
        return Observable.never()
    }
}

extension MAFilterCoordinator {
    enum Target: Equatable {
        case settings
    }
}
