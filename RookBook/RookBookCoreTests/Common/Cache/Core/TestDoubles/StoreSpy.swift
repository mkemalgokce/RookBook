// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore

final class StoreSpy: Storable {
    // MARK: - Typealiases
    typealias Item = Int
    typealias Identifier = String

    // MARK: - Properties
    var stubbedItems: [Int] = []
    var stubbedItem: Int?
    var stubbedError: Error?

    var receivedItems: [Int] = []
    var receivedIDs: [String] = []
    var deletedIDs: [String] = []
    var updatedItems: [Int] = []

    // MARK: - Internal Methods
    func save(_ item: Int) throws {
        if let error = stubbedError { throw error }
        receivedItems.append(item)
    }

    func saveAll(_ items: [Int]) throws {
        if let error = stubbedError { throw error }
        receivedItems.append(contentsOf: items)
    }

    func loadAll() throws -> [Int] {
        if let error = stubbedError { throw error }
        return stubbedItems
    }

    func load(for identifier: String) throws -> Int {
        if let error = stubbedError { throw error }
        receivedIDs.append(identifier)
        return stubbedItem ?? 0
    }

    func update(_ item: Int) throws {
        if let error = stubbedError { throw error }
        updatedItems.append(item)
    }

    func delete(for identifier: String) throws {
        if let error = stubbedError { throw error }
        deletedIDs.append(identifier)
    }

    func deleteAll() throws {
        if let error = stubbedError { throw error }
    }
}
