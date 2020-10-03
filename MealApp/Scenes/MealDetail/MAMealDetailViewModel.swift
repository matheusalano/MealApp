import Foundation
import RxCocoa
import RxSwift

enum MAMealDetailViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MAMealDetailViewModelProtocol {
    var loadData: PublishSubject<Void> { get }

    var state: Driver<MAMealDetailViewModelState> { get }
    var name: Driver<String> { get }
    var area: Driver<String> { get }
    var thumbURL: Driver<URL> { get }
    var instructions: Driver<String> { get }
    var ingredients: Driver<[MAMeal.Ingredient]> { get }
}

final class MAMealDetailViewModel: MAMealDetailViewModelProtocol {
    //MARK: Inputs

    let loadData = PublishSubject<Void>()

    //MARK: Outputs

    let state: Driver<MAMealDetailViewModelState>
    let name: Driver<String>
    let area: Driver<String>
    let thumbURL: Driver<URL>
    let instructions: Driver<String>
    let ingredients: Driver<[MAMeal.Ingredient]>

    init(meal: MAMealBasic, service: MAMealDetailServiceProtocol = MAMealDetailService()) {
        let _state = PublishSubject<MAMealDetailViewModelState>()
        state = _state.asDriver(onErrorRecover: { _ in Driver.empty() })

        let meal = loadData
            .flatMapLatest({
                service.getMeal(from: meal.id)
                    .asObservable()
                    .do(onNext: { _ in
                        _state.onNext(.data)
                        _state.onCompleted()
                    },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError {
                        let error: ServiceError = $0 as? ServiceError ?? .generic
                        _state.onNext(.error(error.readableMessage))
                        return .never()
                    }
            })
            .asDriver(onErrorDriveWith: .never())

        name = meal.map({ $0.meals[0].name })

        area = meal.map({ $0.meals[0].area })

        thumbURL = meal.map({ $0.meals[0].thumbURL })

        instructions = meal.map({ $0.meals[0].instructions })

        ingredients = meal.map({ $0.meals[0].ingredients })
    }
}
