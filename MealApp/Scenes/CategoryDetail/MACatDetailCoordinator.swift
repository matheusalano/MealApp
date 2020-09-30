import RxSwift

final class MACatDetailCoordinator: BaseCoordinator<Void> {
    let viewModel: MACatDetailViewModelProtocol

    var mealDetailCoordinator: BaseCoordinator<Void>?

    init(navigator: AppNavigator, category: MACategory) {
        viewModel = MACatDetailViewModel(category: category)
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MACatDetailViewModelProtocol, mealDetailCoordinator: BaseCoordinator<Void>) {
        self.viewModel = viewModel
        self.mealDetailCoordinator = mealDetailCoordinator
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MACatDetailViewController(viewModel: viewModel)

        viewModel.navigationTarget
            .drive(onNext: { [weak self] target in
                switch target {
                case let .mealDetail(meal: meal):
                    self?.startMealDetail(meal: meal)
                }
            })
            .disposed(by: disposeBag)

        navigator.navigate(to: viewController, using: .push)
        return viewController.rx.deallocated
    }

    private func startMealDetail(meal: MAMealBasic) {
        coordinate(to: mealDetailCoordinator ?? MAMealDetailCoordinator(navigator: navigator, meal: meal))
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension MACatDetailCoordinator {
    enum Target: Equatable {
        case mealDetail(meal: MAMealBasic)
    }
}
