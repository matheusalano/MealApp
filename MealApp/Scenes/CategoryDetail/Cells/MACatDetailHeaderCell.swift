import Nuke
import RxNuke
import RxSwift
import SnapKit
import UIKit

final class MACatDetailHeaderCell: UICollectionViewCell {
    //MARK: Private constants

    private let descriptionLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.textColor = .secondaryLabel
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        return $0
    }(UILabel())

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

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

    //MARK: Private functions

    private func addSubviews() {
        contentView.addSubview(descriptionLabel)
    }

    private func installConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: Internal functions

    func configure(with category: MACategory) {
        descriptionLabel.text = category.description
    }
}
