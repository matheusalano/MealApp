import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MAMealListViewControllerTests: QuickSpec {
    private var viewModel: MAMealListViewModelMock!
    private var sut: MAMealListViewController!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        viewModel = MAMealListViewModelMock(result: result)
        sut = MAMealListViewController(viewModel: viewModel)
    }

    private func start() {
        describe("MACatDetailViewController") {
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

final class MAMealListViewModelMock: MAMealListViewModelProtocol {
    let loadData = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()

    let title = Driver.just("meal title")
    let dataSource: Driver<[MAMealBasic]>
    let state: Driver<MAMealListViewModelState>

    init(result: ResultType) {
        let _state = PublishSubject<MAMealListViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        dataSource = loadData
            .flatMapLatest({ _ -> Observable<MAMealListResponse> in
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
            .map({ $0.meals })
    }
}
