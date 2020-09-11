import Foundation
import RxCocoa
import RxSwift

enum MACategoriesViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MACategoriesViewModelProtocol {
    typealias Target = MACategoriesCoordinator.Target

    var didTapLeftBarButton: PublishSubject<Void> { get }
    var loadCategories: PublishSubject<Void> { get }

    var navigationTarget: Driver<Target> { get }
    var categories: Driver<[MACategory]> { get }
    var state: Driver<MACategoriesViewModelState> { get }
}

final class MACategoriesViewModel: MACategoriesViewModelProtocol {
    //MARK: Inputs

    let didTapLeftBarButton = PublishSubject<Void>()
    let loadCategories = PublishSubject<Void>()

    //MARK: Outputs

    let navigationTarget: Driver<Target>
    let categories: Driver<[MACategory]>
    let state: Driver<MACategoriesViewModelState>

    init(service: MACategoriesServiceProtocol = MACategoriesService()) {
        let _state = PublishSubject<MACategoriesViewModelState>()
        state = _state.asDriver(onErrorRecover: { _ in Driver.empty() })

        categories = loadCategories
            .flatMap({
                service.getCategories()
                    .asObservable()
                    .do(onNext: { _ in _state.onNext(.data) },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError {
                        let error: ServiceError = $0 as? ServiceError ?? .generic
                        _state.onNext(.error(error.readableMessage))
                        return .empty()
                    }
            })
            .asDriver(onErrorRecover: { _ in .empty() })
            .map({ $0.categories })

        navigationTarget = Observable.merge(
            didTapLeftBarButton.map({ .settings })
        ).asDriver(onErrorRecover: { _ in .empty() })
    }
}
