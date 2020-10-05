import SnapKit
import UIKit

final class MAFilterView: UIView {
    let errorView = MAErrorView()

    let tableView: UITableView = {
        $0.register(MAFilterCell.self, forCellReuseIdentifier: MAFilterCell.description())
        return $0
    }(UITableView(frame: .zero, style: .insetGrouped))

    //MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        installConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Private functions

    private func addSubviews() {
        addSubview(tableView)
    }

    private func installConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: Internal functions

    func showError() {
        let view = UIView()
        errorView.insert(onto: view)
        tableView.tableFooterView = view
        tableView.updateTableFooterViewHeight()
    }

    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        tableView.tableFooterView = activityIndicator
    }
}
