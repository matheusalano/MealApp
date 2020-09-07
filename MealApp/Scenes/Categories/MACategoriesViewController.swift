import UIKit

final class MACategoriesViewController: BaseViewController<MACategoriesView> {
    //MARK: Private constants

    let viewModel: MACategoriesViewModelProtocol

    //MARK: Initializers

    init(viewModel: MACategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Overridden functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTabBar()

        setupBindings()
    }

    //MARK: Private functions

    private func setupNavigationBar() {
        title = .localized(by: MAString.Scenes.Categories.title)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
    }

    private func setupTabBar() {
        tabBarItem = UITabBarItem(
            title: .localized(by: MAString.Scenes.Categories.title),
            image: UIImage(systemName: "rectangle.grid.2x2"),
            selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")
        )
    }

    private func setupBindings() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapLeftBarButton)
            .disposed(by: disposeBag)
    }
}
