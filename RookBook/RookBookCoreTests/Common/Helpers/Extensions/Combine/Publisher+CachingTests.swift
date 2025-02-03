// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

final class PublisherCachingTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    // MARK: - Single Item Tests
    func test_cachingSingleItem_savesItemToCache() {
        let cache = makeCache()
        let item = "test item"
        let mappedItem = 42

        expectPublisher(
            Just(item).caching(to: cache) { _ in mappedItem },
            toCompleteWith: .success(item)
        )

        XCTAssertEqual(cache.savedItems, [mappedItem])
    }

    func test_cachingSingleItem_deliversOriginalValue() {
        let cache = makeCache()
        let expectedItem = "test item"

        expectPublisher(
            Just(expectedItem).caching(to: cache) { _ in 42 },
            toCompleteWith: .success(expectedItem)
        )
    }

    func test_cachingSingleItem_doesNotFailOnCacheError() {
        let cache = makeCache()
        cache.shouldFail = true
        let item = "test item"

        expectPublisher(
            Just(item).caching(to: cache) { _ in 42 },
            toCompleteWith: .success(item)
        )
    }

    // MARK: - Collection Tests
    func test_cachingCollection_savesItemsToCache() {
        let cache = makeCache()
        let items = ["item1", "item2"]
        let mappedItems = [1, 2]

        expectPublisher(
            Just(items).caching(to: cache, map: { _ in mappedItems }),
            toCompleteWith: .success(items)
        )

        XCTAssertEqual(cache.savedAllItems.first, mappedItems)
    }

    func test_cachingCollection_deliversOriginalValues() {
        let cache = makeCache()
        let expectedItems = ["item1", "item2"]

        expectPublisher(
            Just(expectedItems).caching(to: cache, map: { _ in 1 }),
            toCompleteWith: .success(expectedItems)
        )
    }

    func test_cachingCollection_doesNotFailOnCacheError() {
        let cache = makeCache()
        cache.shouldFail = true
        let items = ["item1", "item2"]

        expectPublisher(
            Just(items).caching(to: cache, map: { _ in 1 }),
            toCompleteWith: .success(items)
        )
    }

    // MARK: - Helpers
    private typealias SUT = (sut: Any, cache: CacheStoreSpy)

    private func makeCache(
        file: StaticString = #file,
        line: UInt = #line
    ) -> CacheStoreSpy {
        CacheStoreSpy()
    }

    private class CacheStoreSpy: CacheStorable {
        typealias Item = Int
        typealias Identifier = String

        var savedItems: [Int] = []
        var savedAllItems: [[Int]] = []
        var shouldFail = false

        func save(_ item: Int) throws {
            if shouldFail { throw anyNSError() }
            savedItems.append(item)
        }

        func saveAll(_ items: [Int]) throws {
            if shouldFail { throw anyNSError() }
            savedAllItems.append(items)
        }

        func loadAll() throws -> [Int] {
            if shouldFail { throw anyNSError() }
            return []
        }

        func load(for identifier: String) throws -> Int {
            if shouldFail { throw anyNSError() }
            return 0
        }

        func update(_ item: Int) throws {
            if shouldFail { throw anyNSError() }
        }

        func delete(for identifier: String) throws {
            if shouldFail { throw anyNSError() }
        }

        func deleteAll() throws {
            if shouldFail { throw anyNSError() }
        }
    }
}

#if DEBUG
extension Int: @retroactive Cacheable {
    public var cacheTimestamp: Date {
        Date()
    }
}
#endif
