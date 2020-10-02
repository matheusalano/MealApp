import Nuke
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarTransparency(isNavBarTransparent())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavBarTransparency(false)
    }

    // MARK: Private functions

    private func setupBindings() {
        //MARK: Outputs

        viewModel.state
            .do(onSubscribe: { [weak self] in self?.customView.showData(false) })
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    self.customView.loader.beginRefreshing()
                    self.customView.errorView.removeFromSuperview()
                case let .error(error):
                    self.customView.loader.endRefreshing()
                    self.customView.errorView.title = error
                    self.customView.errorView.insert(onto: self.customView)
                case .data:
                    self.customView.loader.endRefreshing()
                    self.customView.showData(true)
                }
            })
            .disposed(by: disposeBag)

        viewModel.name
            .drive(customView.headerView.nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.area
            .drive(customView.headerView.areaLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.thumbURL
            .flatMapLatest { url in
                ImagePipeline.shared.rx.loadImage(with: url)
                    .map({ $0.image })
                    .asDriver(onErrorRecover: { _ in .empty() })
            }
            .drive(customView.headerView.imageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.instructions
            .drive(customView.instructionsView.instructionsLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.ingredients
            .drive(onNext: { [customView] ingredients in
                customView.ingredientsView.addIngredients(ingredients)
            })
            .disposed(by: disposeBag)

        customView.scrollView.rx.didScroll
            .compactMap({ [weak self] in self?.isNavBarTransparent() })
            .distinctUntilChanged()
            .withLatestFrom(viewModel.name, resultSelector: { ($0, $1) })
            .subscribe(onNext: { [weak self] transparent, title in
                self?.title = transparent ? nil : title
                self?.setNavBarTransparency(transparent)
            })
            .disposed(by: disposeBag)

        //MARK: Inputs

        customView.errorView.retryTap
            .bind(to: viewModel.loadData)
            .disposed(by: disposeBag)
    }

    private func isNavBarTransparent() -> Bool {
        (customView.scrollView.contentOffset.y + customView.safeAreaInsets.top) <= 48
    }

    private func setNavBarTransparency(_ transparent: Bool) {
        navigationController?.navigationBar.setBackgroundImage(transparent ? UIImage() : nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = transparent ? UIImage() : nil
    }
}
