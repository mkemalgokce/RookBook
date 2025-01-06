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
