// swiftlint:disable force_cast

import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MAFilterServiceTests: QuickSpec {
    private var service: AppServiceMock<MAFilterResponse>!
    private var sut: MAFilterService!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: Result<MAFilterResponse, ServiceError>) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = AppServiceMock(result: result)
        sut = MAFilterService(service: service)
    }

    private func start() {
        describe("MAFilterService") {
            //MARK: Areas

            when("when areas list is called") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                    self.scheduler.scheduleAt(300) {
                        self.sut.getAreas().subscribe().disposed(by: self.disposeBag)
                    }
                }

                then("then path must be correct") {
                    let observer = self.scheduler.start({ self.service.path })
                    expect(observer.events).to(equal([.next(300, .list)]))
                }

                then("then http method must be correct") {
                    let observer = self.scheduler.start({ self.service.method })
                    expect(observer.events).to(equal([.next(300, .GET)]))
                }

                then("then query items must be correct") {
                    let observer = self.scheduler.start({ self.service.queryItems })
                    expect(observer.events).to(equal([.next(300, [URLQueryItem(name: "a", value: "list")])]))
                }

                then("then body must be correct") {
                    let observer = self.scheduler.start({ self.service.body.map({ $0 as! [String: String] }) })
                    expect(observer.events).to(equal([]))
                }
            }

            when("when areas service fails") {
                beforeEach {
                    self.setup(result: .failure(.generic))
                }

                then("then error must be emited") {
                    let observer = self.scheduler.start({ self.sut.getAreas().asObservable() })
                    expect(observer.events).to(equal([.error(200, ServiceError.generic)]))
                }
            }

            when("when areas service succeeds") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.getAreas().asObservable() })
                    expect(observer.events).to(equal([.next(200, .dummy), .completed(200)]))
                }
            }

            //MARK: Ingredients

            when("when ingredients list is called") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                    self.scheduler.scheduleAt(300) {
                        self.sut.getIngredients().subscribe().disposed(by: self.disposeBag)
                    }
                }

                then("then path must be correct") {
                    let observer = self.scheduler.start({ self.service.path })
                    expect(observer.events).to(equal([.next(300, .list)]))
                }

                then("then http method must be correct") {
                    let observer = self.scheduler.start({ self.service.method })
                    expect(observer.events).to(equal([.next(300, .GET)]))
                }

                then("then query items must be correct") {
                    let observer = self.scheduler.start({ self.service.queryItems })
                    expect(observer.events).to(equal([.next(300, [URLQueryItem(name: "i", value: "list")])]))
                }

                then("then body must be correct") {
                    let observer = self.scheduler.start({ self.service.body.map({ $0 as! [String: String] }) })
                    expect(observer.events).to(equal([]))
                }
            }

            when("when ingredients service fails") {
                beforeEach {
                    self.setup(result: .failure(.generic))
                }

                then("then error must be emited") {
                    let observer = self.scheduler.start({ self.sut.getIngredients().asObservable() })
                    expect(observer.events).to(equal([.error(200, ServiceError.generic)]))
                }
            }

            when("when ingredients service succeeds") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.getIngredients().asObservable() })
                    expect(observer.events).to(equal([.next(200, .dummy), .completed(200)]))
                }
            }
        }
    }
}
