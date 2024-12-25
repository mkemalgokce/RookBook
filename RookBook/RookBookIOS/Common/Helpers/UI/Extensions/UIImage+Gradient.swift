// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIImage {
    func gradientImage(_ colors: [UIColor]) -> UIImage? {
        guard let source = withRenderingMode(.alwaysTemplate).cgImage else {
            return nil
        }
        let cgColors = colors.map(\.cgColor)
        let colors = cgColors as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorsSpace: space,
                                        colors: colors, locations: nil) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(
            bounds: CGRect(origin: .zero, size: size)
        )
        return renderer.image { context in
            let context = context.cgContext
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)

            context.setBlendMode(.normal)
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            // Apply gradient
            context.clip(to: rect, mask: source)
            context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0),
                                       end: CGPoint(x: 0, y: size.height), options: .drawsAfterEndLocation)
        }
    }

    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
