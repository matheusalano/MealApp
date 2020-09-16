import RxSwift
import RxCocoa

@testable import MealApp

final class MACategoriesViewControllerTests: SnapshotTestCase {
    
}

private final class MACategoriesViewModelMock: MACategoriesViewModelProtocol {
    let didTapLeftBarButton = PublishSubject<Void>()
    let loadCategories = PublishSubject<Void>()

    let navigationTarget: Driver<Target> = .never()
    let categories: Driver<[MACategory]>
    let state: Driver<MACategoriesViewModelState> = .never()

    init(result: ResultType) {
        categories = loadCategories
            .flatMapLatest({ _ -> Observable<MACategoriesResponse> in
                switch result {
                case .success:
                    return .just(.dummy)
                case .failure(error: let error):
                    return .error(error)
                }
            })
            .asDriver(onErrorRecover: { _ in .empty() })
            .map({ $0.categories })
    }
}
