// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol Cacheable {
    func toData() throws -> Data
}

extension Cacheable where Self: Encodable {
    public func toData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
