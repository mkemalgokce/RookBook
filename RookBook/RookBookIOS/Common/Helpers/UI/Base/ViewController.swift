// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

public class ViewController<View: UIView>: UIViewController {
    // MARK: - Properties
    var rootView: View {
        view as! View
    }

    // MARK: - Lifecycle Methods
    override public func loadView() {
        view = View()
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
