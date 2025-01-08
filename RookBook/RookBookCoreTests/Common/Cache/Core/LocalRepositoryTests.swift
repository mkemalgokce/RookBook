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
        store.stubbedItems = items

        expectPublisher(
            sut.fetch(),
            toCompleteWith: .success(items)
        )
    }

    func test_fetch_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.stubbedError = expectedError

        expectPublisher(
            sut.fetch(),
            toCompleteWith: .failure(expectedError)
        )
    }

    func test_fetchWithID_deliversItemFromStore() {
        let (sut, store) = makeSUT()
        let item = 1
        store.stubbedItem = item

        expectPublisher(
            sut.fetch(with: "any-id"),
            toCompleteWith: .success(item)
        )

        XCTAssertEqual(store.receivedIDs, ["any-id"])
    }

    func test_fetchWithID_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.stubbedError = expectedError

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

        XCTAssertEqual(store.receivedItems, [item])
    }

    func test_save_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.stubbedError = expectedError

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

        XCTAssertEqual(store.deletedIDs, ["any-id"])
    }

    func test_delete_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.stubbedError = expectedError

        expectPublisher(
            sut.delete(with: "any-id"),
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

        XCTAssertEqual(store.updatedItems, [item])
    }

    func test_update_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError()
        store.stubbedError = expectedError

        expectPublisher(
            sut.update(1),
            toCompleteWith: .failure(expectedError)
        )
    }

    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalRepository<StoreSpy>, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalRepository(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
