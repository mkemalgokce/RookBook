// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIView {
    private var gradientLayer: CAGradientLayer {
        if let layer = layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first {
            return layer
        } else {
            let gradient = CAGradientLayer()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.insertSublayer(gradient, at: 0)
            CATransaction.commit()
            return gradient
        }
    }

    func applyGradient(customFrame: CGRect? = nil, radius: CGFloat = 0, colors: [UIColor], isAnimated: Bool = false) {
        let gradient = gradientLayer

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        gradient.frame = customFrame ?? bounds
        gradient.colors = colors.map(\.cgColor)
        gradient.cornerRadius = radius

        layer.cornerRadius = radius

        CATransaction.commit()
    }
}
