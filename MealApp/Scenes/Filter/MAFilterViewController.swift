import UIKit

final class MAFilterViewController: BaseViewController<MAFilterView> {
    //MARK: Private constants

    let viewModel: MAFilterViewModelProtocol

    //MARK: Initializers

    init(viewModel: MAFilterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupNavigationBar()
        setupTabBar()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Overridden functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    //MARK: Private functions

    private func setupNavigationBar() {
        title = .localized(by: MAString.Scenes.Filter.title)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
    }

    private func setupTabBar() {
        tabBarItem = UITabBarItem(
            title: .localized(by: MAString.Scenes.Filter.title),
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
    }

    private func setupBindings() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapLeftBarButton)
            .disposed(by: disposeBag)
    }
}
