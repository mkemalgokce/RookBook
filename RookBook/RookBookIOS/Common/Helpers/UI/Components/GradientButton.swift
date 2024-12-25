// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class GradientButton: UIButton {
    // MARK: - Properties
    var gradientColors: [UIColor] {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Initializers
    init(colors: [UIColor] = []) {
        gradientColors = colors
        super.init(frame: .zero)

        addTarget(self, action: #selector(animateButtonPress), for: [.touchDown, .touchDragEnter])
        addTarget(
            self,
            action: #selector(animateButtonRelease),
            for: [.touchUpInside, .touchCancel, .touchDragExit]
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()

        if let imageView {
            applyGradient(customFrame: imageView.frame, colors: gradientColors)
            mask = imageView
        }
    }

    // MARK: - Private Methods
    @objc private func animateButtonPress() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    @objc private func animateButtonRelease() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
