// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol CacheStoreConformable {
    associatedtype Item
    typealias CachedElement = (items: [Item], timestamp: Date)

    func deleteCache() throws
    func insert(_ elements: [Item], timestamp: Date) throws
    func retrieve() throws -> CachedElement?
}
