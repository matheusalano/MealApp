import UIKit

enum NavigationMethod {
    case push, present
}

protocol AppNavigatorProtocol {
    func addTabViewController(viewController: UIViewController, visible: Bool)
    func navigate(to viewController: UIViewController, using method: NavigationMethod)
}

final class AppNavigator: AppNavigatorProtocol {
    private weak var tabBarController: UITabBarController?
    private var navigationControllers: [[UINavigationController]]

    var selectedIndex: Int {
        tabBarController?.selectedIndex ?? 0
    }

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        navigationControllers = []
    }

    func addTabViewController(viewController: UIViewController, visible: Bool) {
        var viewControllers = tabBarController?.viewControllers ?? []

        let navigationController = MANavigationController(rootViewController: viewController)

        viewControllers.append(navigationController)
        navigationControllers.append([navigationController])

        tabBarController?.setViewControllers(viewControllers, animated: false)

        if visible {
            tabBarController?.selectedViewController = navigationController
        }
    }

    func navigate(to viewController: UIViewController, using method: NavigationMethod) {
        switch method {
        case .push:
            navigationControllers[selectedIndex].last?.pushViewController(viewController, animated: true)
        case .present:
            let nextNavController = MANavigationController(rootViewController: viewController) { [weak self] in
                guard let self = self else { return }
                self.navigationControllers[self.selectedIndex].removeLast(1)
            }
            navigationControllers[selectedIndex].last?.present(nextNavController, animated: true, completion: nil)
            navigationControllers[selectedIndex].append(nextNavController)
        }
    }
}
