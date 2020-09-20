import RxSwift
// swiftlint:disable force_cast
import UIKit

class BaseViewController<View: UIView>: UIViewController {
    var customView: View {
        return view as! View
    }

    let disposeBag = DisposeBag()

    override func loadView() {
        view = View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customView.backgroundColor = .secondarySystemBackground
    }
}
