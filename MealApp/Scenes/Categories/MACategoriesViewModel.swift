import Foundation
import RxCocoa
import RxSwift

enum MACategoriesViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MACategoriesViewModelProtocol {
    typealias Target = MACategoriesCoordinator.Target

    var didSelectCell: PublishSubject<IndexPath> { get }
    var loadData: PublishSubject<Void> { get }

    var navigationTarget: Driver<Target> { get }
    var dataSource: Driver<[MACategorySectionModel]> { get }
    var state: Driver<MACategoriesViewModelState> { get }
}

final class MACategoriesViewModel: MACategoriesViewModelProtocol {
    //MARK: Inputs

    let didSelectCell = PublishSubject<IndexPath>()
    let loadData = PublishSubject<Void>()

    //MARK: Outputs

    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACategorySectionModel]>
    let state: Driver<MACategoriesViewModelState>

    init(service: MACategoriesServiceProtocol = MACategoriesService()) {
        let _state = PublishSubject<MACategoriesViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        let categories = loadData
            .flatMapLatest({
                service.getCategories()
                    .asObservable()
                    .do(onNext: { _ in _state.onNext(.data) },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError {
                        let error: ServiceError = $0 as? ServiceError ?? .generic
                        _state.onNext(.error(error.readableMessage))
                        return .never()
                    }
            })
            .share(replay: 1)
            .map({ response -> [MACategorySectionModel] in
                [.categorySection(items: response.categories.map({ .category($0) }))]
            })

        let randomMeal = loadData
            .flatMapLatest({
                service.getRandomMeal()
                    .retry(3)
                    .catchError({ _ in .never() })
            })
            .share(replay: 1)
            .map({ response -> [MACategorySectionModel] in
                [.mealSection(items: response.meals.map({ .meal($0) }))]
            })

        dataSource = Observable.merge(
            categories.takeUntil(randomMeal),
            Observable.combineLatest(randomMeal, categories, resultSelector: { $0 + $1 })
        ).asDriver(onErrorDriveWith: .never())

        navigationTarget = didSelectCell.withLatestFrom(dataSource) { (indexPath, data) -> Target in
            switch data[indexPath.section].items[indexPath.row] {
            case let .meal(meal):
                return .mealDetail(meal: meal)
            case let .category(category):
                return .detail(category: category)
            }
        }.asDriver(onErrorDriveWith: .never())
    }
}
