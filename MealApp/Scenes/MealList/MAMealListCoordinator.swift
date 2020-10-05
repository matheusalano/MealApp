import RxSwift

final class MAMealListCoordinator: BaseCoordinator<Void> {
    let viewModel: MAMealListViewModelProtocol

    var mealDetailCoordinator: BaseCoordinator<Void>?

    init(navigator: AppNavigator, filter: MAMealListFilter, value: String) {
        viewModel = MAMealListViewModel(filter: filter, value: value)
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MAMealListViewModelProtocol, mealDetailCoordinator: BaseCoordinator<Void>) {
        self.viewModel = viewModel
        self.mealDetailCoordinator = mealDetailCoordinator
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MAMealListViewController(viewModel: viewModel)

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

extension MAMealListCoordinator {
    enum Target: Equatable {
        case mealDetail(meal: MAMealBasic)
    }
}
