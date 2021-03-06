import Foundation
import RxCocoa
import RxSwift

enum MACatDetailViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MACatDetailViewModelProtocol {
    typealias Target = MACatDetailCoordinator.Target

    var loadData: PublishSubject<Void> { get }
    var didSelectCell: PublishSubject<IndexPath> { get }

    var title: Driver<String> { get }
    var navigationTarget: Driver<Target> { get }
    var dataSource: Driver<[MACatDetailSectionModel]> { get }
    var state: Driver<MACatDetailViewModelState> { get }
}

final class MACatDetailViewModel: MACatDetailViewModelProtocol {
    //MARK: Inputs

    let loadData = PublishSubject<Void>()
    let didSelectCell = PublishSubject<IndexPath>()

    //MARK: Outputs

    let title: Driver<String>
    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACatDetailSectionModel]>
    let state: Driver<MACatDetailViewModelState>

    init(category: MACategory, service: MACatDetailServiceProtocol = MACatDetailService()) {
        let _state = PublishSubject<MACatDetailViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

        title = Driver.just(category.name)

        let meals = loadData
            .flatMapLatest({
                service.getMeals(from: category.name)
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
            .map({ response -> [MACatDetailSectionModel] in
                [.mealSection(items: response.meals.map({ .meal($0) }))]
            })

        dataSource = Driver.combineLatest(
            Driver.just([MACatDetailSectionModel.headerSection(items: [.header(category)])]),
            meals,
            resultSelector: { $0 + $1 }
        )

        let selectedMeal = didSelectCell
            .filter({ $0.section == 1 })
            .withLatestFrom(dataSource) { (indexPath, data) -> MAMealBasic? in
                switch data[indexPath.section].items[indexPath.row] {
                case let .meal(meal):
                    return meal
                case .header(_):
                    return nil
                }
            }
            .compactMap({ $0 })

        navigationTarget = selectedMeal.map({ .mealDetail(meal: $0) }).asDriver(onErrorDriveWith: .never())
    }
}
