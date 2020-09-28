import Nuke
import RxNuke
import RxSwift
import SnapKit
import UIKit

final class MACategoriesMealCell: UICollectionViewCell {
    //MARK: Private constants

    private let neumorphicView = MANeumorphicView()

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

    private let title: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        $0.textColor = .white
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private let subtitle: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .lightText
        $0.text = .localized(by: MAString.Scenes.Categories.mealCellSubtitle)
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
        addSubview(maskImageView)
        addSubview(title)
        addSubview(subtitle)
    }

    private func installConstraints() {
        neumorphicView.snp.makeConstraints({ $0.edges.equalToSuperview() })

        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })

        maskImageView.snp.makeConstraints({ $0.edges.equalToSuperview() })

        snp.makeConstraints {
            let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
            $0.width.equalTo(screenWidth - 48)
            $0.height.equalTo(snp.width).dividedBy(2)
        }

        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }

        subtitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalTo(title.snp.top).offset(-4)
        }
    }

    //MARK: Internal functions

    func configure(with meal: MAMeal) {
        title.text = meal.strMeal

        disposeBag = DisposeBag()
        imageView.image = nil

        ImagePipeline.shared.rx.loadImage(with: meal.strMealThumb)
            .map({ $0.image })
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
