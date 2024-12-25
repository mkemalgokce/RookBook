// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class DividerView: UIView {
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 1).isActive = true
        backgroundColor = UIColor.lightGray
            .withAlphaComponent(0.5)
    }
}
