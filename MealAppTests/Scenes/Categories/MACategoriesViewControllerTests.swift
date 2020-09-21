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
    let loadCategories = PublishSubject<Void>()

    let navigationTarget: Driver<Target> = .never()
    let categories: Driver<[MACategory]>
    let state: Driver<MACategoriesViewModelState> = .never()

    init(result: ResultType) {
        categories = loadCategories
            .flatMapLatest({ _ -> Observable<MACategoriesResponse> in
                switch result {
                case .success:
                    return .just(.dummyVC)
                case let .failure(error: error):
                    return .error(error)
                }
            })
            .asDriver(onErrorRecover: { _ in .empty() })
            .map({ $0.categories })
    }
}
