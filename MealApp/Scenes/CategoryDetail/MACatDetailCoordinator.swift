import RxSwift
import UIKit

final class MACatDetailCoordinator: BaseCoordinator<Void> {
    let viewModel: MACatDetailViewModelProtocol

    init(navigator: AppNavigator, category: MACategory) {
        viewModel = MACatDetailViewModel(category: category)
        super.init(navigator: navigator)
    }

    init(navigator: AppNavigator, viewModel: MACatDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(navigator: navigator)
    }

    override func start() -> Observable<Void> {
        return Observable.never()
    }
}

extension MACatDetailCoordinator {
    enum Target: Equatable {}
}
