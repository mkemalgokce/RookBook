// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore

final class WeakRef<T: AnyObject> {
    // MARK: - Properties
    weak var value: T?

    // MARK: - Initializers
    init(_ value: T) {
        self.value = value
    }
}

extension WeakRef: RookBookCore.OnboardingView where T: RookBookCore.OnboardingView {
    func displayPage(at index: Int) {
        value?.displayPage(at: index)
    }
}
