import Foundation
import RxCocoa
import RxSwift

enum MAMealDetailViewModelState: Equatable {
    case loading, error(_ error: String), data
}

protocol MAMealDetailViewModelProtocol {
    typealias Target = MAMealDetailCoordinator.Target

    var loadData: PublishSubject<Void> { get }

    var state: Driver<MAMealDetailViewModelState> { get }
    var navigationTarget: Driver<Target> { get }
}

final class MAMealDetailViewModel: MAMealDetailViewModelProtocol {
    //MARK: Inputs

    let loadData = PublishSubject<Void>()

    //MARK: Outputs

    let state: Driver<MAMealDetailViewModelState>
    let navigationTarget: Driver<Target>

    init(meal _: MAMealBasic, service _: MAMealDetailServiceProtocol = MAMealDetailService()) {
        let _state = PublishSubject<MAMealDetailViewModelState>()
        state = _state.asDriver(onErrorRecover: { _ in Driver.empty() })

        navigationTarget = Driver.merge(
        )
    }
}
