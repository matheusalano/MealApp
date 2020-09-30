import RxSwift

final class MACategoriesCoordinator: BaseCoordinator<Void> {
    let viewModel: MACategoriesViewModelProtocol

    var categoryDetailCoordinator: BaseCoordinator<Void>?
    var mealDetailCoordinator: BaseCoordinator<Void>?

    override init(navigator: AppNavigator) {
        viewModel = MACategoriesViewModel()
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MACategoriesViewModelProtocol, categoryDetailCoordinator: BaseCoordinator<Void>, mealDetailCoordinator: BaseCoordinator<Void>) {
        self.viewModel = viewModel
        self.categoryDetailCoordinator = categoryDetailCoordinator
        self.mealDetailCoordinator = mealDetailCoordinator
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        let viewController = MACategoriesViewController(viewModel: viewModel)

        viewModel.navigationTarget
            .drive(onNext: { [weak self] target in
                switch target {
                case .settings:
                    //TODO: Go to Settings
                    break
                case let .detail(category):
                    self?.startCategoryDetail(category: category)
                case let .mealDetail(meal: meal):
                    self?.startMealDetail(meal: meal)
                }
            })
            .disposed(by: disposeBag)

        navigator.addTabViewController(viewController: viewController, visible: true)
        return Observable.never()
    }

    private func startCategoryDetail(category: MACategory) {
        coordinate(to: categoryDetailCoordinator ?? MACatDetailCoordinator(navigator: navigator, category: category))
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func startMealDetail(meal: MAMealBasic) {
        coordinate(to: mealDetailCoordinator ?? MAMealDetailCoordinator(navigator: navigator, meal: meal))
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension MACategoriesCoordinator {
    enum Target: Equatable {
        case detail(category: MACategory)
        case mealDetail(meal: MAMealBasic)
        case settings
    }
}
