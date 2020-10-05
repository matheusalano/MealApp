import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MAMealListViewModelTests: QuickSpec {
    private var service: MAMealListServiceMock!
    private var sut: MAMealListViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(mealResult: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = MAMealListServiceMock(mealResult: mealResult)
        sut = MAMealListViewModel(filter: .area, value: "Tst_value", service: service)
    }

    private func start() {
        describe("MAMealListViewModel") {
            when("when the data is requested") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadData)
                        .disposed(by: self.disposeBag)
                    self.sut.dataSource.drive().disposed(by: self.disposeBag)
                }

                then("then meal service must be called") {
                    let observer = self.scheduler.start({ self.service.mealCalled })
                    expect(observer.events).to(equal([.next(300, "area,Tst_value")]))
                }

                then("then loader must be triggered") {
                    let observer = self.scheduler.start({ self.sut.state.asObservable() })
                    expect(observer.events).to(contain([.next(300, .loading)]))
                }
            }

            given("given generic request error") {
                beforeEach {
                    self.setup(mealResult: .failure(error: .generic))
                }

                when("when meal service return") {
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
            }

            when("when meal service returns successfully") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadData)
                        .disposed(by: self.disposeBag)
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.dataSource.asObservable() })
                    expect(observer.events).to(equal([.next(300, [.dummy])]))
                }
            }
        }
    }
}

private final class MAMealListServiceMock: MAMealListServiceProtocol {
    var mealResult: ResultType
    var mealCalled = PublishSubject<String>()

    init(mealResult: ResultType) {
        self.mealResult = mealResult
    }

    func getMeals(filteredBy filter: MAMealListFilter, value: String) -> Single<MAMealListResponse> {
        return Single.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }

            self.mealCalled.onNext("\(filter.rawValue),\(value)")
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
