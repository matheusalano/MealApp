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

    private func setup(categoriesResult: ResultType = .success, mealResult: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = MACategoriesServiceMock(categoriesResult: categoriesResult, mealResult: mealResult)
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

            when("when the data is requested") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadData)
                        .disposed(by: self.disposeBag)
                    self.sut.dataSource.drive().disposed(by: self.disposeBag)
                }

                then("then categories service must be called") {
                    let observer = self.scheduler.start({ self.service.categoriesCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }

                then("then random meal service must be called") {
                    let observer = self.scheduler.start({ self.service.mealCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }

                then("then loader must be triggered") {
                    let observer = self.scheduler.start({ self.sut.state.asObservable() })
                    expect(observer.events).to(contain([.next(300, .loading)]))
                }
            }

            given("given generic request error") {
                beforeEach {
                    self.setup(categoriesResult: .failure(error: .generic), mealResult: .failure(error: .generic))
                }

                when("when categories service return") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(300, ())])
                            .bind(to: self.sut.loadData)
                            .disposed(by: self.disposeBag)
                        self.sut.dataSource.drive().disposed(by: self.disposeBag)
                    }

                    then("then error must be presented") {
                        let observer = self.scheduler.start({ self.sut.state.asObservable() })
                        expect(observer.events).to(contain([.next(300, .loading), .next(300, .error(MAString.Errors.generic))]))
                    }
                }

                when("when meal is requested") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(300, ())])
                            .bind(to: self.sut.loadData)
                            .disposed(by: self.disposeBag)
                        self.sut.dataSource.drive().disposed(by: self.disposeBag)
                    }

                    then("then meal service must retry 3 times") {
                        let observer = self.scheduler.start({ self.service.mealCalled.map({ _ in true }) })
                        expect(observer.events).to(equal([.next(300, true), .next(300, true), .next(300, true)]))
                    }
                }
            }

            when("when categories service returns successfully") {
                beforeEach {
                    self.setup(mealResult: .failure(error: .generic))
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadData)
                        .disposed(by: self.disposeBag)
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.dataSource.asObservable() })
                    expect(observer.events).to(equal([.next(300, [.categorySection(items: [.category(.dummy)])])]))
                }
            }

            when("when all data successfully") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadData)
                        .disposed(by: self.disposeBag)
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.dataSource.asObservable() })
                    expect(observer.events).to(equal([.next(300, [.mealSection(items: [.meal(.dummy)]), .categorySection(items: [.category(.dummy)])])]))
                }
            }
        }
    }
}

private final class MACategoriesServiceMock: MACategoriesServiceProtocol {
    var categoriesResult: ResultType
    var categoriesCalled = PublishSubject<Void>()

    var mealResult: ResultType
    var mealCalled = PublishSubject<Void>()

    init(categoriesResult: ResultType, mealResult: ResultType) {
        self.categoriesResult = categoriesResult
        self.mealResult = mealResult
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

    func getRandomMeal() -> Single<MACategoriesMealResponse> {
        return Single.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }

            self.mealCalled.onNext(())
            switch self.mealResult {
            case .success:
                observer(.success(.dummy))
            case let .failure(error: error):
                observer(.error(error))
            }

            return Disposables.create()
        }
    }
}
