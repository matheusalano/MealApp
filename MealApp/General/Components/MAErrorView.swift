import RxCocoa
import UIKit

final class MAErrorView: UIView {
    //MARK: Private constants

    private let alertImageView: UIImageView = {
        $0.image = UIImage(systemName: "exclamationmark.triangle")
        $0.tintColor = .secondaryLabel
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    private let titleLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private let retryButton: UIButton = {
        $0.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.setTitle(MAString.General.tryAgain, for: .normal)
        return $0
    }(UIButton(type: .system))

    //MARK: Internal variables

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var retryTap: ControlEvent<Void> {
        retryButton.rx.tap
    }

    //MARK: Initializers

    init(title: String? = nil) {
        super.init(frame: .zero)

        titleLabel.text = title

        addSubviews()
        installConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Private functions

    private func addSubviews() {
        addSubview(alertImageView)
        addSubview(titleLabel)
        addSubview(retryButton)
    }

    private func installConstraints() {
        alertImageView.snp.makeConstraints({
            $0.size.equalTo(CGSize(width: 64, height: 64))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
        })

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(alertImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        })

        retryButton.snp.makeConstraints({
            $0.height.greaterThanOrEqualTo(44)
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        })
    }

    //MARK: Internal functions

    func insert(onto view: UIView) {
        view.addSubview(self)

        snp.makeConstraints({
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.top.greaterThanOrEqualToSuperview().offset(24)
            $0.leading.greaterThanOrEqualToSuperview().offset(24)
            $0.bottom.lessThanOrEqualToSuperview().offset(-24)
            $0.trailing.lessThanOrEqualToSuperview().offset(-24)
        })
    }
}
