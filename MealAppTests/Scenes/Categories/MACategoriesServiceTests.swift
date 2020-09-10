// swiftlint:disable force_cast

import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MACategoriesServiceTests: QuickSpec {
    private var service: AppServiceMock<MACategoriesResponse>!
    private var sut: MACategoriesService!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(result: Result<MACategoriesResponse, ServiceError>) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = AppServiceMock(result: result)
        sut = MACategoriesService(service: service)
    }

    private func start() {
        describe("MACategoriesService") {
            when("when categories list is called") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                    self.scheduler.scheduleAt(300) {
                        self.sut.getCategories().subscribe().disposed(by: self.disposeBag)
                    }
                }

                then("then path must be correct") {
                    let observer = self.scheduler.start({ self.service.path })
                    expect(observer.events).to(equal([.next(300, .categories)]))
                }

                then("then http method must be correct") {
                    let observer = self.scheduler.start({ self.service.method })
                    expect(observer.events).to(equal([.next(300, .GET)]))
                }

                then("then query items must be correct") {
                    let observer = self.scheduler.start({ self.service.queryItems })
                    expect(observer.events).to(equal([]))
                }

                then("then body must be correct") {
                    let observer = self.scheduler.start({ self.service.body.map({ $0 as! [String: String] }) })
                    expect(observer.events).to(equal([]))
                }
            }

            when("when categories service fails") {
                beforeEach {
                    self.setup(result: .failure(.generic))
                }

                then("then error must be emited") {
                    let observer = self.scheduler.start({ self.sut.getCategories().asObservable() })
                    expect(observer.events).to(equal([.error(200, ServiceError.generic)]))
                }
            }

            when("when categories service succeeds") {
                beforeEach {
                    self.setup(result: .success(.dummy))
                }

                then("then data must be correct") {
                    let observer = self.scheduler.start({ self.sut.getCategories().asObservable() })
                    expect(observer.events).to(equal([.next(200, .dummy), .completed(200)]))
                }
            }
        }
    }
}
