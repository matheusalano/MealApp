import Nuke
import RxNuke
import RxSwift
import SnapKit
import UIKit

final class MACatDetailMealCell: UICollectionViewCell {
    //MARK: Private constants

    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        return $0
    }(UIImageView())

    private let maskImageView: UIView = {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        return $0
    }(UIView())

    private let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        $0.textColor = .white
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    //MARK: Private variables

    private var disposeBag = DisposeBag()

    //MARK: Overridden variables

    override var isHighlighted: Bool {
        didSet {
            let transform = isHighlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity

            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: { self.transform = transform },
                           completion: nil)
        }
    }

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
        addSubview(maskImageView)
        addSubview(titleLabel)
    }

    private func installConstraints() {
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })

        maskImageView.snp.makeConstraints({ $0.edges.equalToSuperview() })

        snp.makeConstraints {
            let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
            $0.width.equalTo(screenWidth - 48)
            $0.height.equalTo(snp.width).dividedBy(2)
        }

        titleLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    //MARK: Internal functions

    func configure(with meal: MAMealBasic) {
        titleLabel.text = meal.name

        disposeBag = DisposeBag()
        imageView.image = nil

        ImagePipeline.shared.rx.loadImage(with: meal.thumbURL)
            .map({ $0.image })
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
