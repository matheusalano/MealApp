import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MACategoriesViewControllerTests: QuickSpec {
    private var viewModel: MACategoriesViewModelMock!
    private var sut: MACategoriesViewController!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        viewModel = MACategoriesViewModelMock(result: result)
        sut = MACategoriesViewController(viewModel: viewModel)
    }

    private func start() {
        describe("MACategoriesViewController") {
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

private final class MACategoriesViewModelMock: MACategoriesViewModelProtocol {
    let didTapLeftBarButton = PublishSubject<Void>()
    let loadData = PublishSubject<Void>()

    let navigationTarget: Driver<Target> = .never()
    let dataSource: Driver<[MACategorySectionModel]>
    let state: Driver<MACategoriesViewModelState>

    init(result: ResultType) {
        let _state = PublishSubject<MACategoriesViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        let categories = loadData
            .flatMapLatest({ _ -> Observable<MACategoriesResponse> in
                switch result {
                case .success:
                    _state.onNext(.data)
                    return .just(.dummyVC)
                case let .failure(error: error):
                    _state.onNext(.error(error.readableMessage))
                    return .never()
                }
            })
            .share(replay: 1)
            .map({ response -> [MACategorySectionModel] in
                [.categorySection(items: response.categories.map({ .category($0) }))]
            })

        let randomMeal = loadData
            .map({ MACategoriesMealResponse.dummy })
            .map({ response -> [MACategorySectionModel] in
                [.mealSection(items: response.meals.map({ .meal($0) }))]
            })

        dataSource = Observable.combineLatest(randomMeal, categories, resultSelector: { $0 + $1 }).asDriver(onErrorDriveWith: .never())
    }
}
