// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct OnboardingPageViewModel<Image> {
    // MARK: - Properties
    public let title: String
    public let subtitle: String
    public let image: Image

    // MARK: - Initializers
    public init(title: String, subtitle: String, image: Image) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
