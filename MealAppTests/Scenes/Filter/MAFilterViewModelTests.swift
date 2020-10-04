import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MAFilterViewModelTests: QuickSpec {
    private var service: MAFilterServiceMock!
    private var sut: MAFilterViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup(areasResult: ResultType = .success, ingredientsResult: ResultType = .success) {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        service = MAFilterServiceMock(areasResult: areasResult, ingredientsResult: ingredientsResult)
        sut = MAFilterViewModel(service: service)
    }

    private func start() {
        describe("MAFilterViewModel") {
            when("when initialized") {
                beforeEach {
                    self.setup()
                }

                then("then datasource must be correct") {
                    let truth = MAFilterSectionModel.filterSection(
                        items: [.filterOption(.init(title: "By Area", systemImage: "mappin.circle.fill", selected: false)),
                                .filterOption(.init(title: "By main ingredient", systemImage: "i.circle.fill", selected: false))])
                    let observer = self.scheduler.start({ self.sut.dataSource.asObservable() })
                    expect(observer.events).to(equal([.next(200, [truth, .optionSection(items: [])])]))
                }
            }

            when("when area filter is selected") {
                beforeEach {
                    self.setup()

                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 0, section: 0))])
                        .bind(to: self.sut.didSelectCell)
                        .disposed(by: self.disposeBag)
                    self.sut.dataSource.drive().disposed(by: self.disposeBag)
                }

                context("twice") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(350, IndexPath(row: 1, section: 0)), .next(400, IndexPath(row: 0, section: 0))])
                            .bind(to: self.sut.didSelectCell)
                            .disposed(by: self.disposeBag)
                    }

                    then("then service must be called once") {
                        let observer = self.scheduler.start({ self.service.areasCalled.map({ _ in true }) })
                        expect(observer.events).to(equal([.next(300, true)]))
                    }
                }

                then("then service must be called") {
                    let observer = self.scheduler.start({ self.service.areasCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }

                then("then loader must be triggered") {
                    let observer = self.scheduler.start({ self.sut.state.asObservable() })
                    expect(observer.events).to(contain([.next(300, .loading)]))
                }
            }

            when("when ingredient filter is selected") {
                beforeEach {
                    self.setup()

                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 1, section: 0))])
                        .bind(to: self.sut.didSelectCell)
                        .disposed(by: self.disposeBag)
                    self.sut.dataSource.drive().disposed(by: self.disposeBag)
                }

                context("twice") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(350, IndexPath(row: 0, section: 0)), .next(400, IndexPath(row: 1, section: 0))])
                            .bind(to: self.sut.didSelectCell)
                            .disposed(by: self.disposeBag)
                    }

                    then("then service must be called once") {
                        let observer = self.scheduler.start({ self.service.ingredientsCalled.map({ _ in true }) })
                        expect(observer.events).to(equal([.next(300, true)]))
                    }
                }

                then("then service must be called") {
                    let observer = self.scheduler.start({ self.service.ingredientsCalled.map({ _ in true }) })
                    expect(observer.events).to(equal([.next(300, true)]))
                }

                then("then loader must be triggered") {
                    let observer = self.scheduler.start({ self.sut.state.asObservable() })
                    expect(observer.events).to(contain([.next(300, .loading)]))
                }
            }

            given("given generic request error") {
                beforeEach {
                    self.setup(areasResult: .failure(error: .generic), ingredientsResult: .failure(error: .generic))
                }

                when("when area service return") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(300, IndexPath(row: 0, section: 0))])
                            .bind(to: self.sut.didSelectCell)
                            .disposed(by: self.disposeBag)
                        self.sut.dataSource.drive().disposed(by: self.disposeBag)
                    }

                    then("then error must be presented") {
                        let observer = self.scheduler.start({ self.sut.state.asObservable() })
                        expect(observer.events).to(contain([.next(300, .loading), .next(300, .error(.localized(by: MAString.Errors.generic)))]))
                    }
                }

                when("when ingredient service return") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(300, IndexPath(row: 1, section: 0))])
                            .bind(to: self.sut.didSelectCell)
                            .disposed(by: self.disposeBag)
                        self.sut.dataSource.drive().disposed(by: self.disposeBag)
                    }

                    then("then error must be presented") {
                        let observer = self.scheduler.start({ self.sut.state.asObservable() })
                        expect(observer.events).to(contain([.next(300, .loading), .next(300, .error(.localized(by: MAString.Errors.generic)))]))
                    }
                }
            }

            when("when area service return") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 0, section: 0))])
                        .bind(to: self.sut.didSelectCell)
                        .disposed(by: self.disposeBag)
                }

                then("then datasource must be correct") {
                    let truth = MAFilterSectionModel.filterSection(
                        items: [.filterOption(.init(title: "By Area", systemImage: "mappin.circle.fill", selected: true)),
                                .filterOption(.init(title: "By main ingredient", systemImage: "i.circle.fill", selected: false))])

                    let observer = self.scheduler.start({ self.sut.dataSource.asObservable() })
                    expect(observer.events).to(
                        contain([.next(300, [truth, .optionSection(items: [])]),
                                 .next(300, [truth, .optionSection(items: [.option("Opt1"), .option("Opt2")])])]))
                }
            }

            when("when ingredient service return") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 1, section: 0))])
                        .bind(to: self.sut.didSelectCell)
                        .disposed(by: self.disposeBag)
                }

                then("then datasource must be correct") {
                    let truth = MAFilterSectionModel.filterSection(
                        items: [.filterOption(.init(title: "By Area", systemImage: "mappin.circle.fill", selected: false)),
                                .filterOption(.init(title: "By main ingredient", systemImage: "i.circle.fill", selected: true))])

                    let observer = self.scheduler.start({ self.sut.dataSource.asObservable() })
                    expect(observer.events).to(
                        contain([.next(300, [truth, .optionSection(items: [])]),
                                 .next(300, [truth, .optionSection(items: [.option("Opt1"), .option("Opt2")])])]))
                }
            }

            given("given area filter is selected") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 0, section: 0))])
                        .bind(to: self.sut.didSelectCell)
                        .disposed(by: self.disposeBag)
                }

                when("when a area option is selected") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(400, IndexPath(row: 0, section: 1))])
                            .bind(to: self.sut.didSelectCell)
                            .disposed(by: self.disposeBag)
                    }

                    then("then meal list must be requested") {
                        let observer = self.scheduler.start({ self.sut.navigationTarget.asObservable() })
                        expect(observer.events).to(equal([.next(400, .mealsFromArea(area: "Opt1"))]))
                    }
                }
            }

            given("given ingredients filter is selected") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, IndexPath(row: 1, section: 0))])
                        .bind(to: self.sut.didSelectCell)
                        .disposed(by: self.disposeBag)
                }

                when("when a ingredients option is selected") {
                    beforeEach {
                        self.scheduler.createHotObservable([.next(400, IndexPath(row: 1, section: 1))])
                            .bind(to: self.sut.didSelectCell)
                            .disposed(by: self.disposeBag)
                    }

                    then("then meal list must be requested") {
                        let observer = self.scheduler.start({ self.sut.navigationTarget.asObservable() })
                        expect(observer.events).to(equal([.next(400, .mealsWithIngredient(ingredient: "Opt2"))]))
                    }
                }
            }

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
        }
    }
}

private final class MAFilterServiceMock: MAFilterServiceProtocol {
    var areasResult: ResultType
    var areasCalled = PublishSubject<Void>()

    var ingredientsResult: ResultType
    var ingredientsCalled = PublishSubject<Void>()

    init(areasResult: ResultType, ingredientsResult: ResultType) {
        self.areasResult = areasResult
        self.ingredientsResult = ingredientsResult
    }

    func getAreas() -> Single<MAFilterResponse> {
        return Single.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }

            self.areasCalled.onNext(())
            switch self.areasResult {
            case .success:
                observer(.success(.dummy))
            case let .failure(error: error):
                observer(.error(error))
            }

            return Disposables.create()
        }
    }

    func getIngredients() -> Single<MAFilterResponse> {
        return Single.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }

            self.ingredientsCalled.onNext(())
            switch self.ingredientsResult {
            case .success:
                observer(.success(.dummy))
            case let .failure(error: error):
                observer(.error(error))
            }

            return Disposables.create()
        }
    }
}
