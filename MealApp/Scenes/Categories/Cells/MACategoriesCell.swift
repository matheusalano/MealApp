import Nuke
import RxNuke
import RxSwift
import SnapKit
import UIKit

final class MACategoriesCell: UICollectionViewCell {
    //MARK: Private constants

    private let backgroundImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.setContentCompressionResistancePriority(.init(1), for: .vertical)
        $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        return $0
    }(UIImageView())

    private let imageMaskView: UIView = {
        $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        return $0
    }(UIView())

    private let title: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.textColor = .white
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        return $0
    }(UILabel())

    //MARK: Private variables

    private var disposeBag = DisposeBag()

    //MARK: Overridden variables

    override var isHighlighted: Bool {
        didSet {
            let duration = isHighlighted ? 0.45 : 0.4
            let transform = isHighlighted ?
                CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
            let bgColor = isHighlighted ?
                .clear : UIColor.darkGray.withAlphaComponent(0.3)
            let textColor = isHighlighted ? UIColor.label.withAlphaComponent(0.6) : .white
            let animations = {
                self.transform = transform
                self.imageMaskView.backgroundColor = bgColor
                self.title.textColor = textColor
            }

            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: animations,
                           completion: nil)
        }
    }

    //MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        installConstraints()

        layer.cornerRadius = 8
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Private functions

    private func addSubviews() {
        addSubview(backgroundImage)
        addSubview(imageMaskView)
        addSubview(title)
    }

    private func installConstraints() {
        backgroundImage.snp.makeConstraints({
            $0.edges.equalToSuperview()

            let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
            $0.width.equalTo((screenWidth - 64) / 2)
            $0.width.equalTo(backgroundImage.snp.height).multipliedBy(2)
        })

        imageMaskView.snp.makeConstraints {
            $0.edges.equalTo(backgroundImage)
        }

        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }

    //MARK: Internal functions

    func configure(with category: MACategory) {
        title.text = category.name

        disposeBag = DisposeBag()
        backgroundImage.image = nil

        if let url = URL(string: category.thumbURL) {
            let imageRequest = ImageRequest(url: url, processors: [
                ImageProcessors.Resize(size: backgroundImage.bounds.size)
            ])

            ImagePipeline.shared.rx.loadImage(with: imageRequest)
                .map({ $0.image })
                .asDriver(onErrorRecover: { _ in .empty() })
                .drive(backgroundImage.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
