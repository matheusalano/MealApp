import RxSwift

final class MACatDetailCoordinator: BaseCoordinator<Void> {
    let viewModel: MACatDetailViewModelProtocol

    init(navigator: AppNavigator, category: MACategory) {
        viewModel = MACatDetailViewModel(category: category)
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MACatDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MACatDetailViewController(viewModel: viewModel)

        navigator.navigate(to: viewController, using: .push)

        return viewController.rx.deallocated
    }
}

extension MACatDetailCoordinator {
    enum Target: Equatable {}
}
