// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

// MARK: - String: StringConvertible
extension String: StringConvertible {
    public var stringValue: String {
        self
    }
}

// MARK: - UUID: StringConvertible
extension UUID: StringConvertible {
    public var stringValue: String {
        uuidString
    }
}

// MARK: - Int: StringConvertible
extension Int: StringConvertible {
    public var stringValue: String {
        String(self)
    }
}

// MARK: - Double: StringConvertible
extension Double: StringConvertible {
    public var stringValue: String {
        String(self)
    }
}

// MARK: - URL: StringConvertible
extension URL: StringConvertible {
    public var stringValue: String {
        absoluteString
    }
}
