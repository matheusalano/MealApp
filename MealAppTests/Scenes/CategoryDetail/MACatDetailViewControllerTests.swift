import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MACatDetailViewControllerTests: QuickSpec {
    private var viewModel: MACatDetailViewModelMock!
    private var sut: MACatDetailViewController!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        viewModel = MACatDetailViewModelMock(result: result)
        sut = MACatDetailViewController(viewModel: viewModel)
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

private final class MACatDetailViewModelMock: MACatDetailViewModelProtocol {
    let loadData = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()

    let title = Driver.just("category title")
    let navigationTarget: Driver<Target> = .never()
    let dataSource: Driver<[MACatDetailSectionModel]>
    let state: Driver<MACatDetailViewModelState>

    init(result: ResultType) {
        let _state = PublishSubject<MACatDetailViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        let meals = loadData
            .flatMapLatest({ _ -> Observable<MACatDetailResponse> in
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
            .map({ response -> [MACatDetailSectionModel] in
                [.mealSection(items: response.meals.map({ .meal($0) }))]
            })

        dataSource = Driver.combineLatest(
            Driver.just([MACatDetailSectionModel.headerSection(items: [.header(.dummy)])]),
            meals,
            resultSelector: { $0 + $1 }
        )
    }
}
