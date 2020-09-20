import UIKit

final class MANeumorphicView: UIView {
    override class var layerClass: AnyClass {
        return MANeumorphicLayer.self
    }

    private var neumorphicLayer: MANeumorphicLayer? {
        return layer as? MANeumorphicLayer
    }

    var viewDepthType: ShadowLayerType? {
        get {
            return neumorphicLayer?.layerDepthType
        } set {
            if let depthType = newValue {
                neumorphicLayer?.layerDepthType = depthType
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        neumorphicLayer?.neumorphicLayerSubLayer()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        neumorphicLayer?.updateShapeAndPath()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        neumorphicLayer?.neumorphicLayerSubLayer()
        setNeedsDisplay()
    }
}
