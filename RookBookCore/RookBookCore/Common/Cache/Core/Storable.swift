// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine

public protocol Storable {
    associatedtype Item: StorableItem
    func save(_ item: Item) throws
    func loadAll() throws -> [Item]
    func deleteAll() throws
    func load(for identifier: Item.Identifier) throws -> Item
    func delete(for identifier: Item.Identifier) throws
    func update(_ item: Item) throws
}
