import Nimble
import Quick
import RxCocoa
import RxSwift

@testable import MealApp

final class MACategoriesCoordinatorTests: QuickSpec {
    private var disposeBag: DisposeBag!
    private var navigator: AppNavigatorSpy!
    private var viewModel: MACategoriesViewModelMock!
    private var sut: MACategoriesCoordinator!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        disposeBag = DisposeBag()
        navigator = AppNavigatorSpy()

        viewModel = MACategoriesViewModelMock()
        sut = MACategoriesCoordinator(navigator: navigator, viewModel: viewModel)
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
        }
    }
}

private final class MACategoriesViewModelMock: MACategoriesViewModelProtocol {
    let didTapLeftBarButton = PublishSubject<Void>()
    let loadData = PublishSubject<Void>()

    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACategorySectionModel]> = .never()
    let state: Driver<MACategoriesViewModelState> = .never()

    init() {
        navigationTarget = Observable.merge(
            didTapLeftBarButton.map({ .settings })
        ).asDriver(onErrorRecover: { _ in .empty() })
    }
}
