import RxSwift

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
                case let .mealsFromArea(area: area):
                    print(area)
                case let .mealsWithIngredient(ingredient: ingredient):
                    print(ingredient)
                }
            })
            .disposed(by: disposeBag)

        navigator.addTabViewController(viewController: viewController, visible: false)
        return Observable.never()
    }
}

extension MAFilterCoordinator {
    enum Target: Equatable {
        case mealsFromArea(area: String)
        case mealsWithIngredient(ingredient: String)
    }
}
