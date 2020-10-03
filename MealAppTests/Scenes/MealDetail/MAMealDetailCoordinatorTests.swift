import Nimble
import Quick
import RxCocoa
import RxSwift

@testable import MealApp

final class MAMealDetailCoordinatorTests: QuickSpec {
    private var disposeBag: DisposeBag!
    private var navigator: AppNavigatorSpy!
    private var viewModel: MAMealDetailViewModelMock!
    private var sut: MAMealDetailCoordinator!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        disposeBag = DisposeBag()
        navigator = AppNavigatorSpy()

        viewModel = MAMealDetailViewModelMock()
        sut = MAMealDetailCoordinator(navigator: navigator, viewModel: viewModel)
    }

    private func start() {
        describe("MAMealDetailCoordinator") {
            beforeEach {
                self.setup()
            }

            when("when start is called") {
                beforeEach {
                    self.sut.start().subscribe().disposed(by: self.disposeBag)
                }

                then("then the viewController is correct") {
                    expect(self.navigator.viewController).to(beAnInstanceOf(MAMealDetailViewController.self))
                }

                then("then navigation method is correct") {
                    expect(self.navigator.method).to(equal(.push))
                }
            }
        }
    }
}

private final class MAMealDetailViewModelMock: MAMealDetailViewModelProtocol {
    //MARK: Inputs

    let loadData = PublishSubject<Void>()

    //MARK: Outputs

    let state: Driver<MAMealDetailViewModelState> = .never()
        let name: Driver<String> = .never()
    let area: Driver<String> = .never()
        let thumbURL: Driver<URL> = .never()
    let instructions: Driver<String> = .never()
        let ingredients: Driver<[MAMeal.Ingredient]> = .never()
}
