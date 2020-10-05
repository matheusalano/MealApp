import RxDataSources
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

        viewModel.loadData.onNext(())
    }

    //MARK: Private functions

    private func setupNavigationBar() {
        title = MAString.Scenes.Categories.title

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
        navigationItem.largeTitleDisplayMode = .never
    }

    private func setupTabBar() {
        tabBarItem = UITabBarItem(
            title: MAString.Scenes.Categories.title,
            image: UIImage(systemName: "rectangle.grid.2x2"),
            selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")
        )
    }

    private func setupBindings() {
        customView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        //MARK: Outputs

        viewModel.state
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    if !self.customView.refreshControl.isRefreshing { self.customView.refreshControl.beginRefreshing() }
                    self.customView.errorView.removeFromSuperview()
                case let .error(error):
                    self.customView.refreshControl.endRefreshing()
                    self.customView.errorView.title = error
                    self.customView.errorView.insert(onto: self.customView)
                case .data:
                    self.customView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        viewModel.dataSource
            .drive(customView.collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)

        //MARK: Inputs

        navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapLeftBarButton)
            .disposed(by: disposeBag)

        customView.collectionView.rx.itemSelected
            .bind(to: viewModel.didSelectCell)
            .disposed(by: disposeBag)

        customView.refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.loadData)
            .disposed(by: disposeBag)

        customView.errorView.retryTap
            .bind(to: viewModel.loadData)
            .disposed(by: disposeBag)
    }

    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<MACategorySectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MACategorySectionModel>(
            configureCell: { dataSource, collectionView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .category(category):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MACategoriesCell.description(), for: indexPath) as? MACategoriesCell else { return UICollectionViewCell() }
                    cell.configure(with: category)
                    return cell
                case let .meal(meal):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MACategoriesMealCell.description(), for: indexPath) as? MACategoriesMealCell else { return UICollectionViewCell() }
                    cell.configure(with: meal)
                    return cell
                }
            })
    }
}

extension MACategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
        let categoriesWidth = (screenWidth - 64) / 2
        let categoriesSize = CGSize(width: categoriesWidth, height: categoriesWidth * 0.65)

        guard collectionView.numberOfSections == 2 else {
            return categoriesSize
        }

        if indexPath.section == 0 {
            let mealWidth = screenWidth - 48
            return CGSize(width: mealWidth, height: mealWidth / 2)
        } else {
            return categoriesSize
        }
    }
}
