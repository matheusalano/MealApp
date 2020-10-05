import UIKit

final class MAFilterCell: UITableViewCell {
    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: MAFilterCellModel) {
        textLabel?.text = model.title
        imageView?.image = UIImage(systemName: model.systemImage, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        imageView?.tintColor = .label

        accessoryType = model.selected ? .checkmark : .none
    }
}
