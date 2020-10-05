import UIKit

final class MACatDetailView: UIView {
    //MARK: Internal constants

    let errorView = MAErrorView()

    let collectionView: UICollectionView = {
        $0.register(MACatDetailHeaderCell.self, forCellWithReuseIdentifier: MACatDetailHeaderCell.description())
        $0.register(MACatDetailMealCell.self, forCellWithReuseIdentifier: MACatDetailMealCell.description())
        $0.contentInsetAdjustmentBehavior = .always
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: CustomFlowLayout()))

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

final class CustomFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        minimumInteritemSpacing = 16
        minimumLineSpacing = 24
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 24, bottom: minimumInteritemSpacing, right: 24)
        sectionInsetReference = .fromSafeArea
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section == 0 else { return super.layoutAttributesForItem(at: indexPath) }
        guard let collectionView = collectionView else {
            fatalError()
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
