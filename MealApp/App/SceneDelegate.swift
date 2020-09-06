import RxSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appNavigator: AppNavigator?
    var appCoordinator: AppCoordinator?
    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = UITabBarController()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        self.window = window

        let appNavigator = AppNavigator(tabBarController: tabBarController)
        self.appNavigator = appNavigator

        let appCoordinator = AppCoordinator(navigator: appNavigator)

        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)

        window.makeKeyAndVisible()
    }
}
