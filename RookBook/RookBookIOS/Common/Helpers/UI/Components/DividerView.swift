// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class DividerView: UIView {
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private Methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 1).isActive = true
        backgroundColor = UIColor.lightGray
            .withAlphaComponent(0.5)
    }
}
