import UIKit

final class MACategoriesViewController: BaseViewController<MACategoriesView> {
    //MARK: Private constants

    private let viewModel: MACategoriesViewModelProtocol

    //MARK: Initializers

    init(viewModel: MACategoriesViewModelProtocol) {
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
        //MARK: Outputs

        viewModel.state
            .do(onSubscribe: { [weak self] in self?.customView.collectionView.isHidden = true })
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    self.customView.errorView.removeFromSuperview()
                case let .error(error):
                    self.customView.errorView.title = error
                    self.customView.errorView.insert(onto: self.customView)
                case .data:
                    self.customView.collectionView.isHidden = false
                }
            })
            .disposed(by: disposeBag)

        viewModel.categories
            .drive(customView.collectionView.rx.items(cellIdentifier: MACategoriesCell.description(), cellType: MACategoriesCell.self)) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)

        //MARK: Inputs

        navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapLeftBarButton)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .withLatestFrom(rx.viewDidDisappear)
            .map({ _ in () })
            .startWith(())
            .bind(to: viewModel.loadCategories)
            .disposed(by: disposeBag)

        customView.errorView.retryTap
            .bind(to: viewModel.loadCategories)
            .disposed(by: disposeBag)
    }
}

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumInteritemSpacing = 16
        minimumLineSpacing = 24
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 24, bottom: minimumInteritemSpacing, right: 24)
        sectionInsetReference = .fromSafeArea
    }
}
