import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MAFilterCoordinatorTests: QuickSpec {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var navigator: AppNavigatorSpy!
    private var viewModel: MAFilterViewModelMock!
    private var sut: MAFilterCoordinator!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        navigator = AppNavigatorSpy()

        viewModel = MAFilterViewModelMock()
        sut = MAFilterCoordinator(navigator: navigator, viewModel: viewModel)
    }

    private func start() {
        describe("MAFilterCoordinator") {
            beforeEach {
                self.setup()
            }

            when("when start is called") {
                beforeEach {
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then the viewController is correct") {
                    expect(self.navigator.viewController).to(beAnInstanceOf(MAFilterViewController.self))
                }

                then("then the tab is selected") {
                    expect(self.navigator.visible).to(beFalse())
                }
            }
        }
    }
}

private final class MAFilterViewModelMock: MAFilterViewModelProtocol {
    //MARK: Inputs

    let didSelectCell = PublishSubject<IndexPath>()
    let didSelectArea = PublishSubject<Void>()
    let didSelectIngredient = PublishSubject<Void>()

    //MARK: Outputs

    let state: Driver<MAFilterViewModelState> = .never()
    let dataSource: Driver<[MAFilterSectionModel]> = .never()
    let navigationTarget: Driver<Target>

    init() {
        navigationTarget = Observable.merge(
            didSelectArea.map({ .mealsFromArea(area: "test_area") }),
            didSelectIngredient.map({ .mealsWithIngredient(ingredient: "test_ingredient") })
        ).asDriver(onErrorRecover: { _ in .empty() })
    }
}
