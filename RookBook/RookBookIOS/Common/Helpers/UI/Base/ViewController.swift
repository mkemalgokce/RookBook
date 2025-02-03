// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

public class ViewController<View: UIView>: UIViewController {
    // MARK: - Properties
    var rootView: View {
        view as! View
    }

    private lazy var loaderView = LoaderView(frame: view.bounds)

    var isLoading: Bool = false {
        didSet {
            isLoading ? showLoader() : hideLoader()
        }
    }

    // MARK: - Initializers
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override public func loadView() {
        view = View()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Private Methods
    private func showLoader() {
        guard !view.subviews.contains(loaderView) else { return }

        loaderView.frame = view.bounds
        loaderView.alpha = 0
        view.addSubview(loaderView)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.loaderView.alpha = 1
        }
    }

    private func hideLoader() {
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseInOut) { [weak self] in
            self?.loaderView.alpha = 0
        } completion: { [weak self] _ in
            self?.loaderView.removeFromSuperview()
        }
    }
}

// MARK: - ResourceErrorView & ResourceLoadingView
extension ViewController: ResourceErrorView, ResourceLoadingView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        showAlert(message: viewModel.message)
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
}
