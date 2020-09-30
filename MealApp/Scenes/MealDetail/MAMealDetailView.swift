import UIKit

//MARK: - Class

final class MAMealDetailView: UIView {
    //MARK: Internal constants

    let errorView = MAErrorView()

    //MARK: Private constants

    private let scrollView = UIScrollView()

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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func installConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(snp.width)
        }
    }

    //MARK: Internal functions

    func showData(_ visible: Bool) {
        scrollView.isHidden = !visible
    }
}
