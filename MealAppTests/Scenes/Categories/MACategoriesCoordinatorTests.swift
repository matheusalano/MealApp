import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest

@testable import MealApp

final class MACategoriesCoordinatorTests: QuickSpec {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var navigator: AppNavigatorSpy!
    private var viewModel: MACategoriesViewModelMock!
    private var detailCategoryCoordinatorMock: CategoryDetailCoordinatorMock!
    private var sut: MACategoriesCoordinator!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        navigator = AppNavigatorSpy()

        viewModel = MACategoriesViewModelMock()
        detailCategoryCoordinatorMock = CategoryDetailCoordinatorMock(navigator: navigator)
        sut = MACategoriesCoordinator(navigator: navigator, viewModel: viewModel, categoryDetailCoordinator: detailCategoryCoordinatorMock)
    }

    private func start() {
        describe("MACategoriesCoordinator") {
            beforeEach {
                self.setup()
            }

            when("when start is called") {
                beforeEach {
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then the viewController is correct") {
                    expect(self.navigator.viewController).to(beAnInstanceOf(MACategoriesViewController.self))
                }

                then("then the tab is selected") {
                    expect(self.navigator.visible).to(beTrue())
                }
            }

            when("when category is selected") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 0, section: 1))])
                        .bind(to: self.viewModel.didSelectCell)
                        .disposed(by: self.disposeBag)
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then category detail coordinator must be called") {
                    let observer = self.scheduler.start({ self.detailCategoryCoordinatorMock.startCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }
            }
        }
    }
}

private final class MACategoriesViewModelMock: MACategoriesViewModelProtocol {
    let didTapLeftBarButton = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()
    let loadData = PublishSubject<Void>()

    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACategorySectionModel]> = .never()
    let state: Driver<MACategoriesViewModelState> = .never()

    init() {
        navigationTarget = Observable.merge(
            didTapLeftBarButton.map({ .settings }),
            didSelectCell.map({ $0.section == 0 ? .mealDetail(meal: .dummy) : .detail(category: .dummy) })
        ).asDriver(onErrorRecover: { _ in .empty() })
    }
}

private final class CategoryDetailCoordinatorMock: BaseCoordinator<Void> {
    let startCalled = PublishSubject<Void>()

    override func start() -> Observable<Void> {
        startCalled.onNext(())
        return Observable.just(())
    }
}
