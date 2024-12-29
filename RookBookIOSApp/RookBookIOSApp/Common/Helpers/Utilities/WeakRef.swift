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

// MARK: - OnboardingView
extension WeakRef: RookBookCore.OnboardingView where T: RookBookCore.OnboardingView {
    func displayPage(at index: Int) {
        value?.displayPage(at: index)
    }
}

// MARK: - ResourceErrorView
extension WeakRef: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: RookBookCore.ResourceErrorViewModel) {
        value?.display(viewModel)
    }
}

// MARK: - ResourceLoadingView
extension WeakRef: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: RookBookCore.ResourceLoadingViewModel) {
        value?.display(viewModel)
    }
}
