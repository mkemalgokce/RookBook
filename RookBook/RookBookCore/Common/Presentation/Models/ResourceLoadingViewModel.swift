// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public struct ResourceLoadingViewModel: Equatable {
    // MARK: - Properties
    public var isLoading: Bool

    // MARK: - Initializers
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
