// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

final class LocalRepositoryTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func test_fetch_deliversItemsFromStore() {
        let (sut, store) = makeSUT()
        let items = [1, 2, 3]

        store.loadResult = .success(items)

        expectPublisher(
            sut.fetch(),
            toCompleteWith: .success(items)
        )
    }

    func test_fetch_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.loadResult = .failure(expectedError)

        expectPublisher(
            sut.fetch(),
            toCompleteWith: .failure(expectedError)
        )
    }

    func test_fetchWithID_deliversItemFromStore() {
        let (sut, store) = makeSUT()
        let item = 1
        store.loadItemResult = .success(item)

        expectPublisher(
            sut.fetch(with: "any-id"),
            toCompleteWith: .success(item)
        )

        XCTAssertEqual(store.receivedMessages, [.load(identifier: "any-id")])
    }

    func test_fetchWithID_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.loadItemResult = .failure(expectedError)

        expectPublisher(
            sut.fetch(with: "any-id"),
            toCompleteWith: .failure(expectedError)
        )
    }

    func test_save_delegatesToStore() {
        let (sut, store) = makeSUT()
        let item = 1

        expectPublisher(
            sut.save(item),
            toCompleteWith: .success(())
        )

        XCTAssertEqual(store.receivedMessages, [.save(item: item)])
    }

    func test_save_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()

        store.saveResult = .failure(expectedError)

        expectPublisher(
            sut.save(1),
            toCompleteWith: .failure(expectedError)
        )
    }

    func test_delete_delegatesToStore() {
        let (sut, store) = makeSUT()

        expectPublisher(
            sut.delete(with: "any-id"),
            toCompleteWith: .success(())
        )

        XCTAssertEqual(store.receivedMessages, [.delete(identifier: "any-id")])
    }

    func test_delete_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.deleteResult = .failure(expectedError)

        expectPublisher(
            sut.delete(with: "any-id"),
            toCompleteWith: .failure(expectedError)
        )
    }

    func test_deleteAll_delegatesToStore() {
        let (sut, store) = makeSUT()

        expectPublisher(
            sut.deleteAll(),
            toCompleteWith: .success(())
        )

        XCTAssertEqual(store.receivedMessages, [.deleteAll])
    }

    func test_deleteAll_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.deleteAllResult = .failure(expectedError)

        expectPublisher(
            sut.deleteAll(),
            toCompleteWith: .failure(expectedError)
        )
    }

    func test_update_delegatesToStore() {
        let (sut, store) = makeSUT()
        let item = 1

        expectPublisher(
            sut.update(item),
            toCompleteWith: .success(())
        )

        XCTAssertEqual(store.receivedMessages, [.update(item: item)])
    }

    func test_update_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.updateResult = .failure(expectedError)

        expectPublisher(
            sut.update(1),
            toCompleteWith: .failure(expectedError)
        )
    }

    // MARK: - Helpers
    private typealias IntStoreSpy = StoreSpy<Int, String>
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalRepository<IntStoreSpy>, store: IntStoreSpy) {
        let store = IntStoreSpy()
        let sut = LocalRepository(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
