// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct LocalData: Codable, StorableItem, Cacheable, Hashable {
    public var id: URL
    public var data: Data
    public var cacheTimestamp: Date

    public init(id: URL, data: Data, cacheTimestamp: Date = Date()) {
        self.id = id
        self.data = data
        self.cacheTimestamp = cacheTimestamp
    }
}
