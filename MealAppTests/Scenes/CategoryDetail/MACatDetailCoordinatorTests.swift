import Nimble
import Quick
import RxCocoa
import RxSwift

@testable import MealApp

final class MACatDetailCoordinatorTests: QuickSpec {
    private var disposeBag: DisposeBag!
    private var navigator: AppNavigatorSpy!
    private var viewModel: MACatDetailViewModelMock!
    private var sut: MACatDetailCoordinator!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        disposeBag = DisposeBag()
        navigator = AppNavigatorSpy()

        viewModel = MACatDetailViewModelMock()
        sut = MACatDetailCoordinator(navigator: navigator, viewModel: viewModel)
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
        }
    }
}

private final class MACatDetailViewModelMock: MACatDetailViewModelProtocol {
    let loadData = PublishSubject<Void>()

    let title = Driver<String>.never()
    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACatDetailSectionModel]> = .never()
    let state: Driver<MACatDetailViewModelState> = .never()

    init() {
        navigationTarget = .empty()
    }
}
