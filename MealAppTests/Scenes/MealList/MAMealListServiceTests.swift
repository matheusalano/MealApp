// swiftlint:disable force_cast

import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MAMealListServiceTests: QuickSpec {
    private var service: AppServiceMock<MAMealListResponse>!
    private var sut: MAMealListService!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: Result<MAMealListResponse, ServiceError>) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = AppServiceMock(result: result)
        sut = MAMealListService(service: service)
    }

    private func start() {
        describe("MAMealListService") {
            when("when meal list filtered by area is called") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                    self.scheduler.scheduleAt(300) {
                        self.sut.getMeals(filteredBy: .area, value: "Test Area").subscribe().disposed(by: self.disposeBag)
                    }
                }

                then("then path must be correct") {
                    let observer = self.scheduler.start({ self.service.path })
                    expect(observer.events).to(equal([.next(300, .filter)]))
                }

                then("then http method must be correct") {
                    let observer = self.scheduler.start({ self.service.method })
                    expect(observer.events).to(equal([.next(300, .GET)]))
                }

                then("then query items must be correct") {
                    let observer = self.scheduler.start({ self.service.queryItems })
                    expect(observer.events).to(equal([.next(300, [URLQueryItem(name: "a", value: "Test_Area")])]))
                }

                then("then body must be correct") {
                    let observer = self.scheduler.start({ self.service.body.map({ $0 as! [String: String] }) })
                    expect(observer.events).to(equal([]))
                }
            }

            when("when meal list filtered by ingredient is called") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                    self.scheduler.scheduleAt(300) {
                        self.sut.getMeals(filteredBy: .ingredient, value: "Test Ingredient").subscribe().disposed(by: self.disposeBag)
                    }
                }

                then("then path must be correct") {
                    let observer = self.scheduler.start({ self.service.path })
                    expect(observer.events).to(equal([.next(300, .filter)]))
                }

                then("then http method must be correct") {
                    let observer = self.scheduler.start({ self.service.method })
                    expect(observer.events).to(equal([.next(300, .GET)]))
                }

                then("then query items must be correct") {
                    let observer = self.scheduler.start({ self.service.queryItems })
                    expect(observer.events).to(equal([.next(300, [URLQueryItem(name: "i", value: "Test_Ingredient")])]))
                }

                then("then body must be correct") {
                    let observer = self.scheduler.start({ self.service.body.map({ $0 as! [String: String] }) })
                    expect(observer.events).to(equal([]))
                }
            }

            when("when meal service fails") {
                beforeEach {
                    self.setup(result: .failure(.generic))
                }

                then("then error must be emited") {
                    let observer = self.scheduler.start({ self.sut.getMeals(filteredBy: .area, value: "").asObservable() })
                    expect(observer.events).to(equal([.error(200, ServiceError.generic)]))
                }
            }

            when("when meal service succeeds") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.getMeals(filteredBy: .area, value: "").asObservable() })
                    expect(observer.events).to(equal([.next(200, .dummy), .completed(200)]))
                }
            }
        }
    }
}
