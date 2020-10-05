import UIKit

final class MAMealListView: UIView {
    //MARK: Internal constants

    let errorView = MAErrorView()

    let collectionView: UICollectionView = {
        $0.register(MAMealCell.self, forCellWithReuseIdentifier: MAMealCell.description())
        $0.contentInsetAdjustmentBehavior = .always
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: MAMealListFlowLayout()))

    let refreshControl: UIRefreshControl = {
        $0.attributedTitle = NSAttributedString(string: MAString.General.loading)
        return $0
    }(UIRefreshControl())

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
        collectionView.refreshControl = refreshControl
        addSubview(collectionView)
    }

    private func installConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private final class MAMealListFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        minimumInteritemSpacing = 16
        minimumLineSpacing = 24
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 24, bottom: minimumInteritemSpacing, right: 24)
        sectionInsetReference = .fromSafeArea
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
