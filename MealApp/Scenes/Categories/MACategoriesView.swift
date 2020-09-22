import UIKit

final class MACategoriesView: UIView {
    //MARK: Internal constants

    let errorView = MAErrorView()

    let collectionView: UICollectionView = {
        $0.register(MACategoriesCell.self, forCellWithReuseIdentifier: MACategoriesCell.description())
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: ColumnFlowLayout()))

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
        addSubview(collectionView)
    }

    private func installConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
