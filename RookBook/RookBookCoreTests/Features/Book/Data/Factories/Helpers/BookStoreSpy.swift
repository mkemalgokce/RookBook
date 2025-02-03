// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation
import RookBookCore

class BookStoreSpy: BookStore {
    // MARK: - Spy Properties
    private(set) var savedBooks: [LocalBook] = []
    private(set) var savedAllBooks: [[LocalBook]] = []
    private(set) var loadedIdentifiers: [UUID] = []
    private(set) var deletedIdentifiers: [UUID] = []
    private(set) var updatedBooks: [LocalBook] = []
    private(set) var deleteAllCallCount = 0

    // MARK: - Stub Properties
    var stubbedBooks: [LocalBook] = []
    var stubbedBook: LocalBook?
    var stubbedError: Error?

    // MARK: - BookStore Methods
    func save(_ item: LocalBook) throws {
        if let error = stubbedError { throw error }
        savedBooks.append(item)
    }

    func saveAll(_ items: [LocalBook]) throws {
        if let error = stubbedError { throw error }
        savedAllBooks.append(items)
    }

    func loadAll() throws -> [LocalBook] {
        if let error = stubbedError { throw error }
        return stubbedBooks
    }

    func load(for identifier: UUID) throws -> LocalBook {
        if let error = stubbedError { throw error }
        loadedIdentifiers.append(identifier)
        return stubbedBook ?? LocalBook(
            id: identifier,
            title: "any title",
            description: "any description",
            author: "any author",
            coverURL: nil,
            pageCount: 0,
            currentPage: 0,
            lastReadAt: nil,
            isFavorite: false
        )
    }

    func update(_ item: LocalBook) throws {
        if let error = stubbedError { throw error }
        updatedBooks.append(item)
    }

    func delete(for identifier: UUID) throws {
        if let error = stubbedError { throw error }
        deletedIdentifiers.append(identifier)
    }

    func deleteAll() throws {
        if let error = stubbedError { throw error }
        deleteAllCallCount += 1
    }
}
