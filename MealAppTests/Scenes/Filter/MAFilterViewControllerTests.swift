import Nimble
import Quick
import RxCocoa
import RxSwift

@testable import MealApp

final class MAFilterViewControllerTests: QuickSpec {
    private var viewModel: MAFilterViewModelMock!
    private var sut: MAFilterViewController!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        viewModel = MAFilterViewModelMock()
        sut = MAFilterViewController(viewModel: viewModel)
    }

    private func start() {
        describe("MAFilterViewController") {
            given("given viewModel returns successfully") {
                beforeEach {
                    self.setup()
                }

                when("when area is selected") {
                    beforeEach {
                        _ = self.sut.view
                        self.viewModel.didSelectCell.onNext(IndexPath(row: 0, section: 0))
                    }

                    then("then it has valid snapshot") {
                        expect(self.sut).to(haveValidSnapshot(testName: "data_area_selected"))
                    }
                }

                when("when ingredient is selected") {
                    beforeEach {
                        _ = self.sut.view
                        self.viewModel.didSelectCell.onNext(IndexPath(row: 1, section: 0))
                    }

                    then("then it has valid snapshot") {
                        expect(self.sut).to(haveValidSnapshot(testName: "data_ingr_selected"))
                    }
                }

                then("then it has valid snapshot") {
                    expect(self.sut).to(haveValidSnapshot(testName: "data_available"))
                }
            }
        }
    }
}

final class MAFilterViewModelMock: MAFilterViewModelProtocol {
    private enum FilterOption {
        case area
        case ingredients
        case none
    }

    //MARK: Inputs

    let didSelectCell = PublishSubject<IndexPath>()

    //MARK: Outputs

    let state: Driver<MAFilterViewModelState> = .never()
    let dataSource: Driver<[MAFilterSectionModel]>
    let navigationTarget: Driver<Target> = .never()

    init() {
        //MARK: Ingredients

        let ingredients = didSelectCell
            .filter({ $0.section == 0 && $0.row == 1})
            .map({ _ in MAFilterResponse.dummy.list })
            .map({ (FilterOption.ingredients, MAFilterSectionModel.optionSection(items: $0.map({ item in .option(item.value) }))) })
            .share(replay: 1)

        //MARK: Areas

        let areas = didSelectCell
            .filter({ $0.section == 0 && $0.row == 0})
            .map({ _ in MAFilterResponse.dummy.list })
            .map({ (FilterOption.area, MAFilterSectionModel.optionSection(items: $0.map({ item in .option(item.value) }))) })
            .share(replay: 1)

        //MARK: Datasource

        let options = Observable.merge(areas, ingredients)
            .asDriver(onErrorDriveWith: .never())
            .startWith((.none, .optionSection(items: [])))

        dataSource = options
            .map({ filterOption, options in
                var sections: [MAFilterSectionModel] = [
                    .filterSection(items: [.filterOption(.init(title: MAString.Scenes.Filter.byArea, systemImage: "mappin.circle.fill", selected: filterOption == .area)),
                                           .filterOption(.init(title: MAString.Scenes.Filter.byIngredient, systemImage: "i.circle.fill", selected: filterOption == .ingredients))])
                ]

                sections.append(options)
                return sections
            })
            .distinctUntilChanged()
    }
}
