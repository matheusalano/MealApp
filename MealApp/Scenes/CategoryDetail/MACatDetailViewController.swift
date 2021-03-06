import RxDataSources
import UIKit

final class MACatDetailViewController: BaseViewController<MACatDetailView> {
    //MARK: Private constants

    private let viewModel: MACatDetailViewModelProtocol

    //MARK: Initializers

    init(viewModel: MACatDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupNavigationBar()
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
        navigationItem.largeTitleDisplayMode = .never
    }

    private func setupBindings() {
        //MARK: Outputs

        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)

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

    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<MACatDetailSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MACatDetailSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .header(category):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MACatDetailHeaderCell.description(), for: indexPath) as? MACatDetailHeaderCell else { return UICollectionViewCell() }
                    cell.configure(with: category)
                    return cell
                case let .meal(meal):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MAMealCell.description(), for: indexPath) as? MAMealCell else { return UICollectionViewCell() }
                    cell.configure(with: meal)
                    return cell
                }
            })
    }
}
