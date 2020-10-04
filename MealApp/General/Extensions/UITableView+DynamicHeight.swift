import UIKit

extension UITableView {
    func updateTableHeaderViewHeight(completion: ((CGSize) -> Void)? = nil) {
        guard let headerView = tableHeaderView else { return }

        for view in headerView.subviews {
            guard let label = view as? UILabel, label.numberOfLines == 0 else { continue }
            label.preferredMaxLayoutWidth = label.frame.width
        }

        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableHeaderView = headerView
            completion?(size)
        }
    }

    func updateTableFooterViewHeight(completion: ((CGSize) -> Void)? = nil) {
        guard let footerView = tableFooterView else { return }

        for view in footerView.subviews {
            guard let label = view as? UILabel, label.numberOfLines == 0 else { continue }
            label.preferredMaxLayoutWidth = label.frame.width
        }

        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            tableFooterView = footerView
            completion?(size)
        }
    }
}
