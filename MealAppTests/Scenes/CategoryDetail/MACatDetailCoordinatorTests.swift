import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MACatDetailCoordinatorTests: QuickSpec {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var navigator: AppNavigatorSpy!
    private var viewModel: MACatDetailViewModelMock!
    private var mealDetailCoordinatorMock: CoordinatorMock!
    private var sut: MACatDetailCoordinator!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        navigator = AppNavigatorSpy()

        viewModel = MACatDetailViewModelMock()
        mealDetailCoordinatorMock = CoordinatorMock(navigator: navigator)
        sut = MACatDetailCoordinator(navigator: navigator, viewModel: viewModel, mealDetailCoordinator: mealDetailCoordinatorMock)
    }

    private func start() {
        describe("MACatDetailCoordinator") {
            beforeEach {
                self.setup()
            }

            when("when start is called") {
                beforeEach {
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then the viewController is correct") {
                    expect(self.navigator.viewController).to(beAnInstanceOf(MACatDetailViewController.self))
                }

                then("then navigation method is correct") {
                    expect(self.navigator.method).to(equal(.push))
                }
            }

            when("when meal is selected") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 0, section: 0))])
                        .bind(to: self.viewModel.didSelectCell)
                        .disposed(by: self.disposeBag)
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then category detail coordinator must be called") {
                    let observer = self.scheduler.start({ self.mealDetailCoordinatorMock.startCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }
            }
        }
    }
}

private final class MACatDetailViewModelMock: MACatDetailViewModelProtocol {
    let loadData = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()

    let title = Driver<String>.never()
    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACatDetailSectionModel]> = .never()
    let state: Driver<MACatDetailViewModelState> = .never()

    init() {
        navigationTarget = didSelectCell.map({ _ in .mealDetail(meal: .dummy) }).asDriver(onErrorDriveWith: .never())
    }
}

private final class CoordinatorMock: BaseCoordinator<Void> {
    let startCalled = PublishSubject<Void>()

    override func start() -> Observable<Void> {
        startCalled.onNext(())
        return Observable.just(())
    }
}
