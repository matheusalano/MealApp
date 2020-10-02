import UIKit

final class MAMealDetailHeaderView: UIView {
    //MARK: Internal constants

    let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIImageView())

    let nameLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .title3)
        $0.textColor = .label
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        return $0
    }(UILabel())

    let areaLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
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
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(areaLabel)
    }

    private func installConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 96, height: 96))
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }

        areaLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
