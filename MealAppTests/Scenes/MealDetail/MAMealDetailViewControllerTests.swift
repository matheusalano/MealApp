import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MAMealDetailViewControllerTests: QuickSpec {
    private var viewModel: MAMealDetailViewModelMock!
    private var sut: MAMealDetailViewController!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        viewModel = MAMealDetailViewModelMock(result: result)
        sut = MAMealDetailViewController(viewModel: viewModel)
    }

    private func start() {
        describe("MAMealDetailViewController") {
            given("given viewModel returns successfully") {
                beforeEach {
                    self.setup()
                }

                then("then it has valid snapshot") {
                    expect(self.sut).to(haveValidSnapshot(testName: "data_available"))
                }
            }
        }
    }
}

private final class MAMealDetailViewModelMock: MAMealDetailViewModelProtocol {
    //MARK: Inputs

    let loadData = PublishSubject<Void>()

    //MARK: Outputs

    let state: Driver<MAMealDetailViewModelState>
    let name: Driver<String>
    let area: Driver<String>
    let thumbURL: Driver<URL>
    let instructions: Driver<String>
    let ingredients: Driver<[MAMeal.Ingredient]>

    init(result: ResultType) {
        let _state = PublishSubject<MAMealDetailViewModelState>()
        state = _state.asDriver(onErrorRecover: { _ in Driver.empty() })

        let meal = loadData
            .flatMapLatest({ _ -> Observable<MAMealDetailResponse> in
                switch result {
                case .success:
                    _state.onNext(.data)
                    return .just(.dummy)
                case let .failure(error: error):
                    _state.onNext(.error(error.readableMessage))
                    return .never()
                }
            })
            .asDriver(onErrorDriveWith: .never())

        name = meal.map({ $0.meals[0].name })

        area = meal.map({ $0.meals[0].area })

        thumbURL = meal.map({ $0.meals[0].thumbURL })

        instructions = meal.map({ $0.meals[0].instructions })

        ingredients = meal.map({ $0.meals[0].ingredients })
    }
}
