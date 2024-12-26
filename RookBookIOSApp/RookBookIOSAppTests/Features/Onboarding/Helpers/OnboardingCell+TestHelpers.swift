// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
import UIKit

extension OnboardingCell {
    var title: String? {
        titleLabel.text
    }

    var subtitle: String? {
        subtitleLabel.text
    }

    var image: UIImage? {
        imageView.image
    }
}
