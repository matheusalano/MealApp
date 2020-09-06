import RxSwift
import UIKit

final class MACategoriesCoordinator: BaseCoordinator<Void> {
    override func start() -> Observable<Void> {
        let vc = MACategoriesViewController()
        vc.tabBarItem = UITabBarItem(
            title: .localized(by: MAString.Scenes.Categories.title),
            image: UIImage(systemName: "rectangle.grid.2x2"),
            selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")
        )
        navigator.addTabViewController(viewController: vc, visible: true)
        return Observable.never()
    }
}
