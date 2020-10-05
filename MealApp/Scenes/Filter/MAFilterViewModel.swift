import Foundation
import RxCocoa
import RxSwift

enum MAFilterViewModelState: Equatable {
    case loading, error(_ error: String), ingredients, area
}

protocol MAFilterViewModelProtocol {
    typealias Target = MAFilterCoordinator.Target

    var didTapLeftBarButton: PublishSubject<Void> { get }
    var didSelectCell: PublishSubject<IndexPath> { get }

    var state: Driver<MAFilterViewModelState> { get }
    var dataSource: Driver<[MAFilterSectionModel]> { get }
    var navigationTarget: Driver<Target> { get }
}

final class MAFilterViewModel: MAFilterViewModelProtocol {
    //MARK: Inputs

    let didTapLeftBarButton = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()

    //MARK: Outputs

    let state: Driver<MAFilterViewModelState>
    let dataSource: Driver<[MAFilterSectionModel]>
    let navigationTarget: Driver<Target>

    init(service: MAFilterServiceProtocol = MAFilterService()) {
        let _state = PublishSubject<MAFilterViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        let selectedFilter = didSelectCell
            .filter({ $0.section == 0 })
            .compactMap({ FilterOption(rawValue: $0.row) })
            .distinctUntilChanged()

        //MARK: Ingredients

        let ingredientsData = selectedFilter
            .filter({ $0 == .ingredients })
            .takeUntil(_state.filter({ $0 == .ingredients }))
            .flatMapLatest({ _ in
                service.getIngredients()
                    .asObservable()
                    .do(onNext: { _ in _state.onNext(.ingredients) }, onSubscribe: { _state.onNext(.loading) })
                    .catchError {
                        let error: ServiceError = $0 as? ServiceError ?? .generic
                        _state.onNext(.error(error.readableMessage))
                        return .never()
                    }
                    .map({ $0.list })
                    .startWith([])
            })
            .map({ MAFilterSectionModel.optionSection(items: $0.map({ item in .option(item.value) })) })
            .share(replay: 1)

        let ingredients = Observable.merge(
            selectedFilter.filter({ $0 == .ingredients }).withLatestFrom(ingredientsData),
            ingredientsData
        ).map({ (FilterOption.ingredients, $0) })

        //MARK: Areas

        let areasData = selectedFilter
            .filter({ $0 == .area })
            .takeUntil(_state.filter({ $0 == .area }))
            .flatMapLatest({ _ in
                service.getAreas()
                    .asObservable()
                    .do(onNext: { _ in _state.onNext(.area) }, onSubscribe: { _state.onNext(.loading) })
                    .catchError {
                        let error: ServiceError = $0 as? ServiceError ?? .generic
                        _state.onNext(.error(error.readableMessage))
                        return .never()
                    }
                    .map({ $0.list })
                    .startWith([])
            })
            .map({ MAFilterSectionModel.optionSection(items: $0.map({ item in .option(item.value) })) })
            .share(replay: 1)

        let areas = Observable.merge(
            selectedFilter.filter({ $0 == .area }).withLatestFrom(areasData),
            areasData
        ).map({ (FilterOption.area, $0) })

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

        //MARK: Target

        let selectedOption = didSelectCell
            .filter({ $0.section == 1 })
            .withLatestFrom(options, resultSelector: { indexPath, data in (data.0, data.1.items[indexPath.row]) })

        let selectedArea = selectedOption
            .flatMapLatest({ selected -> Observable<String> in
                switch selected {
                case let (.area, .option(value)):
                    return .just(value)
                default:
                    return .never()
                }
            })

        let selectedIngredient = selectedOption
            .flatMapLatest({ selected -> Observable<String> in
                switch selected {
                case let (.ingredients, .option(value)):
                    return .just(value)
                default:
                    return .never()
                }
            })

        navigationTarget = Observable.merge(
            didTapLeftBarButton.map({ .settings }),
            selectedArea.map({ .mealsFromArea(area: $0) }),
            selectedIngredient.map({ .mealsWithIngredient(ingredient: $0) })
        ).asDriver(onErrorRecover: { _ in .empty() })
    }
}

extension MAFilterViewModel {
    private enum FilterOption: Int {
        case area = 0
        case ingredients = 1
        case none = 2
    }
}
