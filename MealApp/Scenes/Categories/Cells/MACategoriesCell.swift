import Nuke
import RxNuke
import RxSwift
import SnapKit
import UIKit

final class MACategoriesCell: UICollectionViewCell {
    //MARK: Private constants

    private let neumorphicView = MANeumorphicView()

    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 26
        $0.clipsToBounds = true
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        return $0
    }(UIImageView())

    private let title: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.textColor = .secondaryLabel
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
            neumorphicView.viewDepthType = isHighlighted ? .innerShadow : .outerShadow
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
        addSubview(neumorphicView)
        addSubview(imageView)
        addSubview(title)
    }

    private func installConstraints() {
        neumorphicView.snp.makeConstraints({ $0.edges.equalToSuperview() })

        imageView.snp.makeConstraints({
            $0.size.equalTo(CGSize(width: 52, height: 52))
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        })

        snp.makeConstraints {
            let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
            $0.width.equalTo((screenWidth - 64) / 2).priority(.init(800))
            $0.width.lessThanOrEqualTo(screenWidth - 64)
            $0.width.equalTo(snp.height).multipliedBy(1.53).priority(.high)
        }

        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.greaterThanOrEqualTo(imageView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    //MARK: Internal functions

    func configure(with category: MACategory) {
        title.text = category.name

        disposeBag = DisposeBag()
        imageView.image = nil

        if let url = URL(string: category.thumbURL) {
            ImagePipeline.shared.rx.loadImage(with: url)
                .map({ $0.image })
                .asDriver(onErrorRecover: { _ in .empty() })
                .drive(imageView.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
