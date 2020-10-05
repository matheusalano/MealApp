import RxSwift

final class MAFilterCoordinator: BaseCoordinator<Void> {
    let viewModel: MAFilterViewModelProtocol

    var mealListCoordinator: BaseCoordinator<Void>?

    override init(navigator: AppNavigator) {
        viewModel = MAFilterViewModel()
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MAFilterViewModelProtocol, mealListCoordinator: BaseCoordinator<Void>) {
        self.viewModel = viewModel
        self.mealListCoordinator = mealListCoordinator
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MAFilterViewController(viewModel: viewModel)

        viewModel.navigationTarget
            .drive(onNext: { [weak self] target in
                switch target {
                case let .mealsFromArea(area: area):
                    self?.startMealList(filter: .area, value: area)
                case let .mealsWithIngredient(ingredient: ingredient):
                    self?.startMealList(filter: .ingredient, value: ingredient)
                }
            })
            .disposed(by: disposeBag)

        navigator.addTabViewController(viewController: viewController, visible: false)
        return Observable.never()
    }

    private func startMealList(filter: MAMealListFilter, value: String) {
        coordinate(to: mealListCoordinator ?? MAMealListCoordinator(navigator: navigator, filter: filter, value: value))
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension MAFilterCoordinator {
    enum Target: Equatable {
        case mealsFromArea(area: String)
        case mealsWithIngredient(ingredient: String)
    }
}
