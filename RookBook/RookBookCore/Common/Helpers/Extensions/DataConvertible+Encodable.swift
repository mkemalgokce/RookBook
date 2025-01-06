// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

extension DataConvertible where Self: Encodable {
    public func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
