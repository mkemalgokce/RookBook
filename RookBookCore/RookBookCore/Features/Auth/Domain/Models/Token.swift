// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct Token {
    // MARK: - Properties
    public let value: String

    // MARK: - Initializers
    public init(_ value: String) {
        self.value = value
    }
}

// MARK: - Token: StringConvertible
extension Token: StringConvertible {
    public var stringValue: String {
        value
    }
}
