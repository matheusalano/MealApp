import UIKit

//MARK: - Class

final class MAMealDetailViewController: BaseViewController<MAMealDetailView> {
    //MARK: Private constants

    private let viewModel: MAMealDetailViewModelProtocol

    //MARK: Initializers

    init(viewModel: MAMealDetailViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Overridden functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()

        viewModel.loadData.onNext(())
    }

    // MARK: Private functions

    private func setupBindings() {
        viewModel.state
            .do(onSubscribe: { [weak self] in self?.showData(false) })
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    break
                case let .error(error):
                    self.customView.errorView.title = error
                    self.customView.errorView.insert(onto: self.customView)
                case .data:
                    self.showData(true)
                }
            })
            .disposed(by: disposeBag)
    }

    private func showData(_ visible: Bool) {
        customView.showData(visible)
    }
}
