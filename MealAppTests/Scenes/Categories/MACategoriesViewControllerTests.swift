import RxCocoa
import RxSwift

@testable import MealApp

final class MACategoriesViewControllerTests: SnapshotTestCase {
    func testCategoriesAvailable() {
        assertViewController(matching: {
            let viewModel = MACategoriesViewModelMock(result: .success)
            return MACategoriesViewController(viewModel: viewModel)
        })
    }
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
                    return .just(.dummyVC)
                case let .failure(error: error):
                    return .error(error)
                }
            })
            .asDriver(onErrorRecover: { _ in .empty() })
            .map({ $0.categories })
    }
}
