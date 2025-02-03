// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
import Foundation

extension BookCell {
    var nameText: String? {
        nameLabel.text
    }

    var descriptionText: String? {
        descriptionLabel.text
    }

    var authorText: String? {
        authorLabel.text
    }

    var isImageLoading: Bool {
        logoImageView.isShimmering
    }

    var renderedImage: Data? {
        logoImageView.image?.pngData()
    }
}
