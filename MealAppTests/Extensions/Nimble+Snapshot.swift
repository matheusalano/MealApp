import Nimble
import SnapshotTesting

public func haveValidSnapshot<Value, Format>(
    as strategy: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) -> Predicate<Value> {
    return Predicate { actualExpression in
        guard let value = try actualExpression.evaluate() else {
            return PredicateResult(status: .fail, message: .fail("have valid snapshot"))
        }

        guard let errorMessage = verifySnapshot(
            matching: value,
            as: strategy,
            named: name,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        ) else {
                return PredicateResult(bool: true, message: .fail("have valid snapshot"))
        }

        return PredicateResult(
            bool: false,
            message: .fail(errorMessage)
        )
    }
}

public func haveValidSnapshot(
    testName: String,
    wait: TimeInterval? = nil,
    viewHeight _: CGFloat? = nil,
    record recording: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
) -> Predicate<UIViewController> {
    return Predicate { actualExpression in
        guard let value = try actualExpression.evaluate() else {
            return PredicateResult(status: .fail, message: .fail("have valid snapshot"))
        }

        let scale = "\(UIScreen.main.scale)".prefix(1)
        let iOS = UIDevice.current.systemVersion.substring(to: ".")

        UIView.setAnimationsEnabled(false)
        let navigationController = UINavigationController(rootViewController: value)
        let tabBar = UITabBarController()
        tabBar.setViewControllers([navigationController], animated: false)

        var snapImages = [
            (Snapshotting.image(on: .iPhoneXr), "iPhoneXr"),
            (Snapshotting.image(on: .iPhoneXr(.landscape)), "iPhoneXrLand"),
            (Snapshotting.image(on: .iPhoneSe), "iPhoneSe"),
            (Snapshotting.image(on: .iPhoneSe(.landscape)), "iPhoneSeLand")
        ]

        if let wait = wait {
            snapImages = snapImages.map({ (Snapshotting.wait(for: wait, on: $0.0), $0.1) })
        }

        let snapResults = snapImages.map { strategy, name in
            verifySnapshot(
                matching: tabBar,
                as: strategy,
                named: "\(name)(\(iOS))@\(scale)x",
                record: recording,
                file: file,
                testName: testName,
                line: line
            )
        }

        let snapErrors = snapResults.compactMap({ $0 })

        guard snapErrors.isEmpty == false else {
            return PredicateResult(bool: true, message: .fail("have valid snapshot"))
        }

        var err: ExpectationMessage = .fail(snapErrors[0])
        snapErrors.dropFirst().forEach({ err = err.appended(message: $0) })

        return PredicateResult(
            bool: false,
            message: err
        )
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
