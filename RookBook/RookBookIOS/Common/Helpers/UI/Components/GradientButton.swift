// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class GradientButton: AnimatableButton {
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
}
