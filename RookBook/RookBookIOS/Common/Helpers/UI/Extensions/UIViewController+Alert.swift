// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.
import UIKit

// MARK: - Alert Management
extension UIViewController {
    public func showAlert(
        title: String? = nil,
        message: String?,
        actions: [(title: String, action: (() -> Void)?)] = [(title: "OK", action: nil)]

    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .green3
        alert.view.tintColor = .green1
        actions.forEach { title, action in
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in action?() }))
        }
        present(alert, animated: true, completion: nil)
    }

    public func hideAlert(animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
}

// MARK: - Loader Management
private var loaderViewTag: Int { 999_999_081 }

extension UIViewController {
    public var isLoading: Bool {
        get { view.viewWithTag(loaderViewTag)?.isHidden == false }
        set { newValue ? showLoader() : hideLoader() }
    }

    func showLoader() {
        guard view.viewWithTag(loaderViewTag) == nil else { return }

        let loaderView = LoaderView(frame: view.bounds)
        loaderView.tag = loaderViewTag
        view.addSubview(loaderView)
    }

    func hideLoader() {
        view.viewWithTag(loaderViewTag)?.removeFromSuperview()
    }
}
