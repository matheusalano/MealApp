// swiftlint:disable force_cast
import UIKit

class BaseViewController<View: UIView>: UIViewController {
    var customView: View {
        return view as! View
    }

    override func loadView() {
        view = View()
    }
}
