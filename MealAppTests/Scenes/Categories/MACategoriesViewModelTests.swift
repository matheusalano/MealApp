import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MACategoriesViewModelTests: QuickSpec {
    private var service: MACategoriesServiceMock!
    private var sut: MACategoriesViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(categoriesResult: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = MACategoriesServiceMock(categoriesResult: categoriesResult)
        sut = MACategoriesViewModel(service: service)
    }

    private func start() {
        describe("MACategoriesViewModel") {
            when("when left bar button is pressed") {
                beforeEach {
                    self.setup()

                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.didTapLeftBarButton)
                        .disposed(by: self.disposeBag)
                }

                then("then settings scene must be requested") {
                    let observer = self.scheduler.start({ self.sut.navigationTarget.asObservable() })
                    expect(observer.events).to(equal([.next(300, .settings)]))
                }
            }

            when("when the categories are requested") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadCategories)
                        .disposed(by: self.disposeBag)
                    self.sut.categories.drive().disposed(by: self.disposeBag)
                }

                then("then categories service must be called") {
                    let observer = self.scheduler.start({ self.service.categoriesCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }

                then("then loader must be triggered") {
                    let observer = self.scheduler.start({ self.sut.state.asObservable() })
                    expect(observer.events).to(contain([.next(300, .loading)]))
                }
            }

            given("given generic request error") {
                beforeEach {
                    self.setup(categoriesResult: .failure(error: .generic))
                }

                when("when categories service return") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(300, ())])
                            .bind(to: self.sut.loadCategories)
                            .disposed(by: self.disposeBag)
                        self.sut.categories.drive().disposed(by: self.disposeBag)
                    }

                    then("then error must be presented") {
                        let observer = self.scheduler.start({ self.sut.state.asObservable() })
                        expect(observer.events).to(contain([.next(300, .loading), .next(300, .error(.localized(by: MAString.Errors.generic)))]))
                    }
                }
            }

            when("when categories service return successfully") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadCategories)
                        .disposed(by: self.disposeBag)
                }

                then("then error must be presented") {
                    let observer = self.scheduler.start({ self.sut.categories.asObservable() })
                    expect(observer.events).to(equal([.next(300, [.dummy])]))
                }
            }
        }
    }
}

private final class MACategoriesServiceMock: MACategoriesServiceProtocol {
    var categoriesResult: ResultType
    var categoriesCalled = PublishSubject<Void>()

    init(categoriesResult: ResultType) {
        self.categoriesResult = categoriesResult
    }

    func getCategories() -> Single<MACategoriesResponse> {
        categoriesCalled.onNext(())

        switch categoriesResult {
        case .success:
            return .just(.dummy)
        case let .failure(error: error):
            return .error(error)
        }
    }
}
