import Foundation
import RxCocoa
import RxSwift

enum MACatDetailViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MACatDetailViewModelProtocol {
    typealias Target = MACatDetailCoordinator.Target

    var loadData: PublishSubject<Void> { get }

    var navigationTarget: Driver<Target> { get }
    var dataSource: Driver<[MACatDetailSectionModel]> { get }
    var state: Driver<MACategoriesViewModelState> { get }
}

final class MACatDetailViewModel: MACatDetailViewModelProtocol {
    //MARK: Inputs

    let loadData = PublishSubject<Void>()

    //MARK: Outputs

    let navigationTarget: Driver<Target>
    let dataSource: Driver<[MACatDetailSectionModel]>
    let state: Driver<MACategoriesViewModelState>

    init(category: MACategory, service: MACatDetailServiceProtocol = MACatDetailService()) {
        let _state = PublishSubject<MACategoriesViewModelState>()
        state = _state.asDriver(onErrorDriveWith: .never())

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

        navigationTarget = Observable.merge(
        ).asDriver(onErrorDriveWith: .never())
    }
}
