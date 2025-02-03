// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore

final class StoreSpy<Item, Identifier: StringConvertible>: Storable {
    // MARK: - Nested Types
    enum Message: Equatable {
        case save(item: Item)
        case saveAll(items: [Item])
        case loadAll
        case load(identifier: Identifier)
        case update(item: Item)
        case delete(identifier: Identifier)
        case deleteAll

        static func ==(lhs: StoreSpy<Item, Identifier>.Message, rhs: StoreSpy<Item, Identifier>.Message) -> Bool {
            switch (lhs, rhs) {
            case let (.save(lhsItem), .save(rhsItem)):
                return lhsItem as AnyObject === rhsItem as AnyObject
            case let (.saveAll(lhsItems), .saveAll(rhsItems)):
                return lhsItems as AnyObject === rhsItems as AnyObject
            case (.loadAll, .loadAll):
                return true
            case let (.load(lhsIdentifier), .load(rhsIdentifier)):
                return lhsIdentifier == rhsIdentifier
            case let (.update(lhsItem), .update(rhsItem)):
                return lhsItem as AnyObject === rhsItem as AnyObject
            case let (.delete(lhsIdentifier), .delete(rhsIdentifier)):
                return lhsIdentifier == rhsIdentifier
            case (.deleteAll, .deleteAll):
                return true
            default:
                return false
            }
        }
    }

    private struct EmptyResultError: Error {}

    // MARK: - Stubbed Results
    var saveResult: Result<Void, Error>?
    var saveAllResult: Result<Void, Error>?
    var loadResult: Result<[Item], Error>?
    var loadItemResult: Result<Item, Error>?
    var updateResult: Result<Void, Error>?
    var deleteResult: Result<Void, Error>?
    var deleteAllResult: Result<Void, Error>?

    // MARK: - receivedMessages.appended Messages
    private(set) var receivedMessages: [Message] = []

    // MARK: - Storable Methods
    func save(_ item: Item) throws {
        receivedMessages.append(.save(item: item))
        try saveResult?.get()
    }

    func saveAll(_ items: [Item]) throws {
        receivedMessages.append(.saveAll(items: items))
        try saveAllResult?.get()
    }

    func loadAll() throws -> [Item] {
        receivedMessages.append(.loadAll)
        return try loadResult?.get() ?? []
    }

    func load(for identifier: Identifier) throws -> Item {
        receivedMessages.append(.load(identifier: identifier))
        if let result = loadItemResult {
            return try result.get()
        }
        throw EmptyResultError()
    }

    func update(_ item: Item) throws {
        receivedMessages.append(.update(item: item))
        try updateResult?.get()
    }

    func delete(for identifier: Identifier) throws {
        receivedMessages.append(.delete(identifier: identifier))
        try deleteResult?.get()
    }

    func deleteAll() throws {
        receivedMessages.append(.deleteAll)
        try deleteAllResult?.get()
    }
}
