import Foundation
import RxCocoa
import RxSwift

enum MAMealListViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MAMealListViewModelProtocol {
    typealias Target = MAMealListCoordinator.Target

    var loadData: PublishSubject<Void> { get }
    var didSelectCell: PublishSubject<IndexPath> { get }

    var title: Driver<String> { get }
    var dataSource: Driver<[MAMealBasic]> { get }
    var state: Driver<MAMealListViewModelState> { get }
    var navigationTarget: Driver<Target> { get }
}

final class MAMealListViewModel: MAMealListViewModelProtocol {
    let loadData = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()

    let title: Driver<String>
    let dataSource: Driver<[MAMealBasic]>
    let state: Driver<MAMealListViewModelState>
    let navigationTarget: Driver<Target>

    init(filter: MAMealListFilter, value: String, service: MAMealListServiceProtocol = MAMealListService()) {
        title = .just(value)

        let _state = PublishSubject<MAMealListViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        dataSource = loadData
            .flatMapLatest({
                service.getMeals(filteredBy: filter, value: value)
                    .asObservable()
                    .do(onNext: { _ in _state.onNext(.data) },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError {
                        let error: ServiceError = $0 as? ServiceError ?? .generic
                        _state.onNext(.error(error.readableMessage))
                        return .never()
                    }
            })
            .asDriver(onErrorDriveWith: .never())
            .map({ $0.meals })

        let selectedMeal = didSelectCell
            .withLatestFrom(dataSource) { (indexPath, data) -> MAMealBasic in
                data[indexPath.row]
            }

        navigationTarget = selectedMeal.map({ .mealDetail(meal: $0) }).asDriver(onErrorDriveWith: .never())
    }
}
