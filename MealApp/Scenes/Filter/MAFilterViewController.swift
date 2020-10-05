import RxCocoa
import RxDataSources
import RxSwift
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
        title = MAString.Scenes.Filter.title
    }

    private func setupTabBar() {
        tabBarItem = UITabBarItem(
            title: MAString.Scenes.Filter.title,
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
    }

    private func setupBindings() {
        //MARK: Outputs

        viewModel.state
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    self.customView.tableView.allowsSelection = false
                    self.customView.showLoading()
                case let .error(error):
                    self.customView.tableView.allowsSelection = false
                    self.customView.errorView.title = error
                    self.customView.showError()
                case .ingredients, .area:
                    self.customView.tableView.tableFooterView = nil
                    self.customView.tableView.allowsSelection = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.dataSource
            .drive(customView.tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)

        //MARK: Inputs

        customView.tableView.rx.itemSelected
            .bind(to: viewModel.didSelectCell)
            .disposed(by: disposeBag)

        customView.errorView.retryTap
            .withLatestFrom(customView.tableView.rx.itemSelected)
            .bind(to: viewModel.didSelectCell )
            .disposed(by: disposeBag)
    }

    private func dataSource() -> RxTableViewSectionedReloadDataSource<MAFilterSectionModel> {
        return RxTableViewSectionedReloadDataSource<MAFilterSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .filterOption(model):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MAFilterCell.description(), for: indexPath) as? MAFilterCell else { return UITableViewCell() }
                    cell.configure(with: model)
                    return cell
                case let .option(title):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                    cell.accessoryType = .disclosureIndicator
                    cell.textLabel?.text = title
                    return cell
                }
            })
    }
}
