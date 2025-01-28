// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

public class ViewController<View: UIView>: UIViewController {
    // MARK: - Properties
    var rootView: View {
        view as! View
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
