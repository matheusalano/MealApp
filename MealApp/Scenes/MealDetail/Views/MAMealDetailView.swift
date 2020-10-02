import UIKit

//MARK: - Class

final class MAMealDetailView: UIView {
    //MARK: Internal constants

    let errorView = MAErrorView()

    let loader: UIRefreshControl = {
        $0.attributedTitle = NSAttributedString(string: .localized(by: MAString.General.loading))
        return $0
    }(UIRefreshControl())

    let scrollView = UIScrollView()

    let headerView = MAMealDetailHeaderView()

    let instructionsView = MAMealDetailInstructionsView()

    let ingredientsView = MAMealDetailIngredientsView()

    //MARK: Private constants

    private let contentView = UIView()

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
        scrollView.refreshControl = loader
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(instructionsView)
        contentView.addSubview(ingredientsView)
    }

    private func installConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(safeAreaLayoutGuide.snp.width)
        }

        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        instructionsView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        ingredientsView.snp.makeConstraints {
            $0.top.equalTo(instructionsView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    //MARK: Internal functions

    func showData(_ visible: Bool) {
        contentView.isHidden = !visible

        if visible { scrollView.refreshControl = nil }
    }
}
