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
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
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

    //MARK: Private functions

    private func addSubviews() {
        addSubview(descriptionLabel)
    }

    private func installConstraints() {
        snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 48) })

        descriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: Internal functions

    func configure(with category: MACategory) {
        descriptionLabel.text = category.description
    }
}
