import UIKit

final class MANavigationController: UINavigationController {
    let dismissCompletion: () -> Void

    init(rootViewController: UIViewController, dismissCompletion: @escaping (() -> Void)) {
        self.dismissCompletion = dismissCompletion
        super.init(rootViewController: rootViewController)

        setupNavigationBar()
    }

    override init(rootViewController: UIViewController) {
        dismissCompletion = {}
        super.init(rootViewController: rootViewController)

        setupNavigationBar()
    }

    init() {
        dismissCompletion = {}
        super.init(nibName: nil, bundle: nil)

        setupNavigationBar()
    }

    required init?(coder aDecoder: NSCoder) {
        dismissCompletion = {}
        super.init(coder: aDecoder)

        setupNavigationBar()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissCompletion()
    }

    private func setupNavigationBar() {
        navigationBar.prefersLargeTitles = true
    }
}
