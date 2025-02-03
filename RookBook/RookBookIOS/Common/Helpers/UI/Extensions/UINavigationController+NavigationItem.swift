// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIViewController {
    func addPlusButtonToNavigationBar(target: Any?, action: Selector) {
        let button = AnimatableButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let largeImage = UIImage(systemName: "plus", withConfiguration: largeConfig)
        button.setImage(largeImage, for: .normal)
        button.setImage(largeImage, for: .highlighted)
        button.setImage(largeImage, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .green1.withAlphaComponent(0.7)
        button.addTarget(self, action: action, for: .touchUpInside)

        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true

        let item = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = item
    }
}
