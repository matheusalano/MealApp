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
    private var mealListCoordinatorMock: CoordinatorMock!
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
        mealListCoordinatorMock = CoordinatorMock(navigator: navigator)
        sut = MAFilterCoordinator(navigator: navigator, viewModel: viewModel, mealListCoordinator: mealListCoordinatorMock)
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

            when("when filter is selected") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.viewModel.didSelectArea)
                        .disposed(by: self.disposeBag)
                    self.scheduler.createHotObservable([.next(350, ())])
                        .bind(to: self.viewModel.didSelectIngredient)
                        .disposed(by: self.disposeBag)
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then category detail coordinator must be called") {
                    let observer = self.scheduler.start({ self.mealListCoordinatorMock.startCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true), .next(350, true)]))
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

private final class CoordinatorMock: BaseCoordinator<Void> {
    let startCalled = PublishSubject<Void>()

    override func start() -> Observable<Void> {
        startCalled.onNext(())
        return Observable.just(())
    }
}
