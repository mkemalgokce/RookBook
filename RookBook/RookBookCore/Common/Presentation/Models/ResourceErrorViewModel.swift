// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public struct ResourceErrorViewModel: Equatable {
    // MARK: - Static Methods
    static func error(message: String) -> Self {
        self.init(message: message)
    }

    // MARK: - Properties
    public var message: String?
}
