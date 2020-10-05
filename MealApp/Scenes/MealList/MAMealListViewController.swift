import RxDataSources
import UIKit

final class MAMealListViewController: BaseViewController<MAMealListView> {
    //MARK: Private constants

    private let viewModel: MAMealListViewModelProtocol

    //MARK: Initializers

    init(viewModel: MAMealListViewModelProtocol) {
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
            .drive(customView.collectionView.rx.items(cellIdentifier: MAMealCell.description(), cellType: MAMealCell.self)) { _, meal, cell in
                cell.configure(with: meal)
            }
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
}
