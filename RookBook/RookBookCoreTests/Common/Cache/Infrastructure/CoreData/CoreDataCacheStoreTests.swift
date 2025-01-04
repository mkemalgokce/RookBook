// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import CoreData
import XCTest

final class CoreDataCacheStoreTests: XCTestCase {
    func test_init_doesNotMessageStore() throws {
        let map: (String) -> Data = { $0.data(using: .utf8)! }
        let reMap: (Data) -> String = { String(data: $0, encoding: .utf8)! }
        let store = try makeStore()
        _ = SUT(store: store, map: map, reMap: reMap)
    }

    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()
        assertThatRetrieveDeliversNotFound(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() throws {
        let sut = try makeSUT()
        assertThatRetrieveDeliversNotFound(on: sut)
        assertThatRetrieveDeliversNotFound(on: sut)
    }

    func test_insert_deliversNoErrorOnEmptyCache() throws {
        let sut = try makeSUT()
        try insert(["a"], to: sut)
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
        let sut = try makeSUT()
        let timestamp = Date()

        try insert(["a"], to: sut, timestamp: timestamp)

        XCTAssertThrowsError(try sut.insert(["b"], timestamp: timestamp))
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
        let sut = try makeSUT()
        let items = ["a", "b", "c"]
        let timestamp = Date()

        try insert(items, to: sut, timestamp: timestamp)

        let cached = try sut.retrieve()
        XCTAssertEqual(cached?.items, items)
        XCTAssertEqual(cached?.timestamp, timestamp)
    }

    func test_retrieve_deliversEmptyValuesOnEmptyCache() throws {
        let sut = try makeSUT()

        try insert([], to: sut)

        let cached = try sut.retrieve()

        XCTAssertEqual(cached?.items, [])
    }

    func test_delete_emptiesCache() throws {
        let sut = try makeSUT()

        try insert(["a"], to: sut)
        try sut.deleteCache()

        assertThatRetrieveDeliversNotFound(on: sut)
    }

    func test_storeSideEffects_runSerially() throws {
        let sut = try makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "Operation 1")
        let op2 = expectation(description: "Operation 2")
        let op3 = expectation(description: "Operation 3")

        let timestamp = Date()

        DispatchQueue.global().async {
            try? sut.insert(["a"], timestamp: timestamp)
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }

        DispatchQueue.global().async {
            try? sut.deleteCache()
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        DispatchQueue.global().async {
            try? sut.insert(["b"], timestamp: timestamp)
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }

        wait(for: [op1, op2, op3], timeout: 5.0)

        XCTAssertEqual(completedOperationsInOrder.count, 3, "Expected 3 operations")
    }

    // MARK: - Helpers
    private typealias SUT = CoreDataCacheStore<String>
    private typealias Store = CoreDataStore<CacheEntity>

    private func makeSUT(
        identifier: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> SUT {
        let store = try makeStore()
        let sut = SUT(store: store, identifier: identifier)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return sut
    }

    private func makeStore() throws -> Store {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        return try Store(
            storeURL: storeURL,
            modelName: "CacheStore",
            in: Bundle(for: SUT.self)
        )
    }

    private func assertThatRetrieveDeliversNotFound(
        on sut: SUT,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try sut.retrieve(), file: file, line: line) { error in
            XCTAssertEqual(error as NSError, Store.StoreError.itemNotFound as NSError, file: file, line: line)
        }
    }

    private func insert(
        _ items: [String],
        to sut: SUT,
        timestamp: Date = Date(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        try sut.insert(items, timestamp: timestamp)
    }
}
