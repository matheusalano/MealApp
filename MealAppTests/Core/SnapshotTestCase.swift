import SnapshotTesting
import UIKit
import XCTest

class SnapshotTestCase: XCTestCase {
    var record = false

    func assertViewController(matching: () -> UIViewController, wait: TimeInterval? = nil, viewHeight: CGFloat? = nil, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        UIView.setAnimationsEnabled(false)

        let vc = { () -> UIViewController in
            let navigationController = UINavigationController(rootViewController: matching())
            let tabBar = UITabBarController()
            tabBar.setViewControllers([navigationController], animated: false)
            return tabBar
        }

        assertDefaultSnapshot(matching: vc, wait: wait, viewHeight: viewHeight, file: file, testName: testName, line: line)
    }

    private func assertDefaultSnapshot(matching value: () -> UIViewController, wait: TimeInterval? = nil, viewHeight: CGFloat? = nil, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let scale = "\(UIScreen.main.scale)".prefix(1)
        let iOS = UIDevice.current.systemVersion.substring(to: ".")

        var snapImages = [
            (Snapshotting.image(on: .iPhoneXr), "iPhoneXr"),
            (Snapshotting.image(on: .iPhoneXr(.landscape)), "iPhoneXrLand"),
            (Snapshotting.image(on: .iPhoneSe), "iPhoneSe"),
            (Snapshotting.image(on: .iPhoneSe(.landscape)), "iPhoneSeLand")
        ]

        var recursiveDescription = Snapshotting.recursiveDescription(on: .iPhoneXr)

        if let wait = wait {
            snapImages = snapImages.map({ (Snapshotting.wait(for: wait, on: $0.0), $0.1) })
            recursiveDescription = .wait(for: wait, on: recursiveDescription)
        }

        snapImages.forEach { snapshotting, name in
            assertSnapshot(matching: value(), as: snapshotting, named: "\(name)(\(iOS))@\(scale)x", record: record, file: file, testName: testName, line: line)
        }

        assertSnapshot(matching: value(), as: recursiveDescription, record: record, file: file, testName: testName, line: line)

        if let viewHeight = viewHeight {
            var customHeight = Snapshotting.image(on: .init(safeArea: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 320, height: viewHeight), traits: .init()))

            if let wait = wait { customHeight = .wait(for: wait, on: customHeight) }

            assertSnapshot(matching: value(),
                           as: customHeight,
                           named: "customHeight(\(iOS))@\(scale)x",
                           record: record,
                           file: file,
                           testName: testName,
                           line: line)
        }
    }
}

private extension String {
    func substring(to: String) -> String {
        if let index = range(of: to) {
            return String(self[..<index.lowerBound])
        }
        return self
    }
}
