// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public final class CoreDataCacheStore<Item>: CacheStoreConformable {
    // MARK: - Properties
    private let store: CoreDataStore<CacheEntity>
    private let map: (Item) throws -> Data
    private let reMap: (Data) throws -> Item
    private let identifier: String

    // MARK: - Initializers
    public init(store: CoreDataStore<CacheEntity>,
                map: @escaping (Item) throws -> Data,
                reMap: @escaping (Data) throws -> Item,
                identifier: String? = nil) {
        self.store = store
        self.map = map
        self.identifier = identifier ?? String(describing: Item.self)
        self.reMap = reMap
    }

    public init(store: CoreDataStore<CacheEntity>, identifier: String? = nil) where Item: Codable {
        self.store = store
        map = { try JSONEncoder().encode($0) }
        reMap = { try JSONDecoder().decode(Item.self, from: $0) }
        self.identifier = identifier ?? String(describing: Item.self)
    }

    // MARK: - Public Methods
    public func insert(_ elements: [Item], timestamp: Date) throws {
        let dataItems = try elements.map { item in
            try DataEntity.Item(
                id: UUID(),
                data: map(item)
            )
        }

        let cacheItem = CacheEntity.Item(
            id: identifier,
            items: dataItems,
            timestamp: timestamp
        )

        try store.save(cacheItem)
    }

    public func deleteCache() throws {
        try store.deleteAll()
    }

    public func retrieve() throws -> CachedElement? {
        let item = try store.load(for: identifier)
        let items = try item.items.map { dataItem in
            try reMap(dataItem.data)
        }

        return CachedElement(
            items: items,
            timestamp: item.timestamp
        )
    }
}
