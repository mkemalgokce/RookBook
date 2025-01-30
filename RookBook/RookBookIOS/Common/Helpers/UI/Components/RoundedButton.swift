// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class RoundedButton: AnimatableButton {
    // MARK: - Initializers
    init(title: String?, backgroundColor: UIColor, textColor: UIColor, iconImage: UIImage? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView(iconImage: iconImage, titleColor: textColor, backgroundColor: backgroundColor)
        setTitle(title, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 4
    }

    // MARK: - Private Methods
    private func setupView(iconImage: UIImage?, titleColor: UIColor, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor

        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)

        setImage(iconImage, for: .normal)
        setImage(iconImage, for: .highlighted)

        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)

        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 4).isActive = true
    }
}
