//
//  Kindly adapted from https://github.com/SimformSolutionsPvtLtd/SSNeumorphicKit
//

import Foundation
import UIKit

enum ShadowLayerType {
    case innerShadow, outerShadow
}

final class MANeumorphicLayer: CALayer {
    //MARK: Private constants

    private let neumorphicShadowOffset = CGSize(width: 5, height: 5)
    private let neumorphicShadowOpacity: Float = 1
    private let neumorphicShadowRadius: CGFloat = 4
    private let neumorphicCornerRadius: CGFloat = 8
    private let elementDepth: CGFloat = 2

    //MARK: Private variables

    private var darkShadowLayer = CAShapeLayer()
    private var lightShadowLayer = CAShapeLayer()

    private var neumorphicMainColor: CGColor {
        defer { setNeedsDisplay() }
        return UIColor.secondarySystemBackground.cgColor
    }

    private var neumorphicDarkShadowColor: CGColor {
        defer { setNeedsDisplay() }
        return UIColor.darkShadow.cgColor
    }

    private var neumorphicLightShadowColor: CGColor {
        defer { setNeedsDisplay() }
        return UIColor.lightShadow.cgColor
    }

    //MARK: Internal variables

    var layerDepthType: ShadowLayerType = .outerShadow {
        didSet { neumorphicLayerSubLayer() }
    }

    override var bounds: CGRect {
        didSet { updateShapeAndPath() }
    }

    //MARK: Private functions

    private func neumorphicShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = neumorphicMainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = neumorphicShadowOpacity
        layer.shadowRadius = neumorphicShadowRadius
        return layer
    }

    private func drawShadowPath() -> CGPath {
        guard bounds.size.isZero == false else { return UIBezierPath(rect: bounds).cgPath }

        var shadowBounds = bounds
        shadowBounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        var path = UIBezierPath()

        let cornerRadii = CGSize(width: neumorphicCornerRadius, height: neumorphicCornerRadius)
        let cornerRadiusInner = neumorphicCornerRadius
        let cornerRadiiInner = CGSize(width: cornerRadiusInner, height: cornerRadiusInner)

        if layerDepthType == .innerShadow {
            path = UIBezierPath(roundedRect: bounds.insetBy(dx: -100, dy: -100),
                                byRoundingCorners: .allCorners,
                                cornerRadii: cornerRadii)
            let innerPath = UIBezierPath(roundedRect: shadowBounds.insetBy(dx: 1, dy: 1),
                                         byRoundingCorners: .allCorners,
                                         cornerRadii: cornerRadiiInner).reversing()
            path.append(innerPath)
        } else {
            path = UIBezierPath(roundedRect: shadowBounds.insetBy(dx: elementDepth / 2.0, dy: elementDepth / 2.0),
                                byRoundingCorners: .allCorners,
                                cornerRadii: cornerRadiiInner)
        }
        return path.cgPath
    }

    private func drawShadowMask() -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: neumorphicCornerRadius).cgPath
        return layer
    }

    //MARK: Internal functions

    func neumorphicLayerSubLayer() {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.clear.cgColor
            self.masksToBounds = self.layerDepthType == .outerShadow ? false : true
            self.darkShadowLayer.removeFromSuperlayer()
            self.lightShadowLayer.removeFromSuperlayer()
            let darkLayer = self.neumorphicShadowLayer(shadowColor: self.neumorphicDarkShadowColor, shadowOffset: self.neumorphicShadowOffset)
            self.insertSublayer(darkLayer, at: 0)
            self.darkShadowLayer = darkLayer
            let lightLayer = self.neumorphicShadowLayer(shadowColor: self.neumorphicLightShadowColor, shadowOffset: self.neumorphicShadowOffset.inverse)
            self.insertSublayer(lightLayer, at: 0)
            self.lightShadowLayer = lightLayer
            self.updateShapeAndPath()
        }
    }

    func updateShapeAndPath() {
        darkShadowLayer.path = drawShadowPath()
        lightShadowLayer.path = drawShadowPath()
        if layerDepthType == .innerShadow {
            darkShadowLayer.mask = drawShadowMask()
            lightShadowLayer.mask = drawShadowMask()
        }
    }
}

//MARK: CGSize

private extension CGSize {
    var inverse: CGSize {
        .init(width: -1 * width, height: -1 * height)
    }

    var isZero: Bool {
        width.isZero && height.isZero
    }
}

//MARK: UIColor

private extension UIColor {
    static var darkShadow: UIColor {
        return UIColor {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.73)
            case .dark:
                return UIColor(red: 0, green: 0, blue: 0, alpha: 0.51)
            @unknown default:
                return UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.73)
            }
        }
    }

    static var lightShadow: UIColor {
        return UIColor {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            case .dark:
                return UIColor(red: 0.765, green: 0.784, blue: 0.804, alpha: 0.1)
            @unknown default:
                return UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
            }
        }
    }
}
