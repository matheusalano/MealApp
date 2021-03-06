// swiftlint:disable force_cast

import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MACatDetailServiceTests: QuickSpec {
    private var service: AppServiceMock<MACatDetailResponse>!
    private var sut: MACatDetailService!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: Result<MACatDetailResponse, ServiceError>) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = AppServiceMock(result: result)
        sut = MACatDetailService(service: service)
    }

    private func start() {
        describe("MACatDetailService") {
            when("when meals list is called") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                    self.scheduler.scheduleAt(300) {
                        self.sut.getMeals(from: "test_cat").subscribe().disposed(by: self.disposeBag)
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
                    expect(observer.events).to(equal([.next(300, [URLQueryItem(name: "c", value: "test_cat")])]))
                }

                then("then body must be correct") {
                    let observer = self.scheduler.start({ self.service.body.map({ $0 as! [String: String] }) })
                    expect(observer.events).to(equal([]))
                }
            }

            when("when meals service fails") {
                beforeEach {
                    self.setup(result: .failure(.generic))
                }

                then("then error must be emited") {
                    let observer = self.scheduler.start({ self.sut.getMeals(from: "").asObservable() })
                    expect(observer.events).to(equal([.error(200, ServiceError.generic)]))
                }
            }

            when("when meals service succeeds") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.getMeals(from: "").asObservable() })
                    expect(observer.events).to(equal([.next(200, .dummy), .completed(200)]))
                }
            }
        }
    }
}
