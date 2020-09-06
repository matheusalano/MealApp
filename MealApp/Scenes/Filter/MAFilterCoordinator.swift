import RxSwift
import UIKit

final class MAFilterCoordinator: BaseCoordinator<Void> {
    override func start() -> Observable<Void> {
        let vc = MAFilterViewController()
        vc.tabBarItem = UITabBarItem(
            title: .localized(by: MAString.Scenes.Filter.title),
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        navigator.addTabViewController(viewController: vc, visible: false)
        return Observable.never()
    }
}
