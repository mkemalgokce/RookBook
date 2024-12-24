// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

extension String: StringConvertible {
    public var stringValue: String {
        self
    }
}

extension UUID: StringConvertible {
    public var stringValue: String {
        uuidString
    }
}

extension Int: StringConvertible {
    public var stringValue: String {
        String(self)
    }
}

extension Double: StringConvertible {
    public var stringValue: String {
        String(self)
    }
}

extension URL: StringConvertible {
    public var stringValue: String {
        absoluteString
    }
}
