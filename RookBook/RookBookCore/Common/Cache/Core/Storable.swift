// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine

public protocol Storable {
    associatedtype Item
    associatedtype Identifier: StringConvertible

    func save(_ item: Item) throws
    func saveAll(_ items: [Item]) throws
    func loadAll() throws -> [Item]
    func deleteAll() throws
    func load(for identifier: Identifier) throws -> Item
    func delete(for identifier: Identifier) throws
    func update(_ item: Item) throws
}

public final class AnyStorable<Item, Identifier: StringConvertible>: Storable {
    private let _save: (Item) throws -> Void
    private let _saveAll: ([Item]) throws -> Void
    private let _loadAll: () throws -> [Item]
    private let _deleteAll: () throws -> Void
    private let _load: (Identifier) throws -> Item
    private let _delete: (Identifier) throws -> Void
    private let _update: (Item) throws -> Void

    public init<Store: Storable>(_ store: Store) where Store.Item == Item, Store.Identifier == Identifier {
        _save = store.save
        _saveAll = store.saveAll
        _loadAll = store.loadAll
        _deleteAll = store.deleteAll
        _load = store.load
        _delete = store.delete
        _update = store.update
    }

    public func save(_ item: Item) throws {
        try _save(item)
    }

    public func saveAll(_ items: [Item]) throws {
        try _saveAll(items)
    }

    public func loadAll() throws -> [Item] {
        try _loadAll()
    }

    public func deleteAll() throws {
        try _deleteAll()
    }

    public func load(for identifier: Identifier) throws -> Item {
        try _load(identifier)
    }

    public func delete(for identifier: Identifier) throws {
        try _delete(identifier)
    }

    public func update(_ item: Item) throws {
        try _update(item)
    }
}
