import UIKit

@testable import MealApp

final class AppNavigatorSpy: AppNavigator {
    var viewController: UIViewController?
    var visible: Bool?
    var method: NavigationMethod?

    init() {
        super.init(tabBarController: UITabBarController())
    }

    override func addTabViewController(viewController: UIViewController, visible: Bool) {
        self.viewController = viewController
        self.visible = visible
    }

    override func navigate(to viewController: UIViewController, using method: NavigationMethod) {
        self.viewController = viewController
        self.method = method
    }
}
