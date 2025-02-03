// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
import UIKit

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }

    static var emptyPlaceholder: UIImage? {
        let image = UIImage(systemName: "photo.on.rectangle.angled")
        let tintedImage = image?.withTintColor(.green1.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        return tintedImage
    }
}

extension Data? {
    static var emptyImageData: Data? {
        let image: UIImage? = .emptyPlaceholder
        return image?.pngData()
    }
}
