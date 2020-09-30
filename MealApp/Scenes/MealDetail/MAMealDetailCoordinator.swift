import RxSwift

final class MAMealDetailCoordinator: BaseCoordinator<Void> {
    let viewModel: MAMealDetailViewModelProtocol

    init(navigator: AppNavigator, meal: MAMealBasic) {
        viewModel = MAMealDetailViewModel(meal: meal)
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MAMealDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MAMealDetailViewController(viewModel: viewModel)

        navigator.navigate(to: viewController, using: .push)

        return viewController.rx.deallocated
    }
}

extension MAMealDetailCoordinator {
    enum Target: Equatable {
        case pop
    }
}
