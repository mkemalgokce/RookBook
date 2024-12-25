// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

class GradientView: UIView {
    // MARK: - Properties
    var gradientColors: [UIColor] = []

    // MARK: - Initializers
    convenience init(gradientColors: [UIColor]) {
        self.init()
        self.gradientColors = gradientColors
    }

    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        applyGradient(colors: gradientColors)
    }
}
