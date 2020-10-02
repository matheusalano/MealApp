import UIKit

final class MAMealDetailIngredientsView: UIView {
    //MARK: Internal constants

    let titleLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.textColor = .label
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.text = "Ingredients"
        return $0
    }(UILabel())

    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView())

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
        addSubview(titleLabel)
        addSubview(stackView)
    }

    private func installConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    func addIngredients(_ ingredients: [MAMeal.Ingredient]) {
        stackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
            stackView.removeArrangedSubview($0)
        })

        ingredients.forEach({
            let labelValue = LabelValueView(label: $0.name, value: $0.measure)
            stackView.addArrangedSubview(labelValue)
        })
    }
}

final class LabelValueView: UIView {
    let labelView: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .label
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    let valueLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UILabel())

    private let separatorView: UIView = {
        $0.backgroundColor = .systemGray3
        return $0
    }(UIView())

    //MARK: Initializers

    init(label: String, value: String) {
        super.init(frame: .zero)

        labelView.text = label
        valueLabel.text = value

        addSubviews()
        installConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Private functions

    private func addSubviews() {
        addSubview(labelView)
        addSubview(valueLabel)
        addSubview(separatorView)
    }

    private func installConstraints() {
        labelView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(separatorView.snp.top)
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(labelView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(separatorView.snp.top)
        }

        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(labelView.snp.leading)
            $0.trailing.equalTo(valueLabel.snp.trailing)
        }
    }
}
