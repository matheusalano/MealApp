import UIKit

final class MACategoriesView: UIView {
    //MARK: Internal constants

    let errorView = MAErrorView()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: layout.minimumInteritemSpacing, left: 24, bottom: layout.minimumInteritemSpacing, right: 24)
        layout.sectionInsetReference = .fromSafeArea
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MACategoriesCell.self, forCellWithReuseIdentifier: MACategoriesCell.description())
        cv.register(MACategoriesMealCell.self, forCellWithReuseIdentifier: MACategoriesMealCell.description())
        cv.backgroundColor = .clear
        cv.alwaysBounceVertical = true

        return cv
    }()

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
