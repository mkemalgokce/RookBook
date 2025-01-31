// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

final class BookCompositeFactoryTests: XCTestCase {
    // MARK: - Tests - Remote with Local Fallback Loader (Single Book)
    func test_makeRemoteWithLocalFallbackLoader_onSuccessfulRemoteLoad_cachesAndDeliversRemoteBook() {
        let book = makeBook()
        let (sut, client, store) = makeSUT()

        let data = encode(BookDTOMapper.map(book))
        expectPublisher(
            sut.makeRemoteWithLocalFallbackLoader(id: book.id),
            toCompleteWith: .success(book),
            when: {
                client.complete(with: data, and: anyHTTPURLResponse())
            }
        )

        XCTAssertEqual(store.savedBooks, [LocalBookMapper.map(book)])
    }

    func test_makeRemoteWithLocalFallbackLoader_onRemoteFailure_deliversCachedBook() {
        let book = makeBook()
        let (sut, client, store) = makeSUT()
        store.stubbedBook = LocalBookMapper.map(book)

        expectPublisher(
            sut.makeRemoteWithLocalFallbackLoader(id: book.id),
            toCompleteWith: .success(book),
            when: {
                client.complete(withError: anyNSError())
            }
        )
    }

    // MARK: - Tests - Remote with Local Fallback Loader (Multiple Books)
    func test_makeRemoteWithLocalFallbackLoader_onSuccessfulRemoteLoad_cachesAndDeliversRemoteBooks() {
        let books = [makeBook(), makeBook()]
        let (sut, client, store) = makeSUT()

        let data = encode(BookResponse(items: books.map(BookDTOMapper.map)))
        expectPublisher(
            sut.makeRemoteWithLocalFallbackLoader(),
            toCompleteWith: .success(books),
            when: {
                client.complete(with: data, and: anyHTTPURLResponse())
            }
        )

        XCTAssertEqual(store.savedAllBooks, [books.map(LocalBookMapper.map)])
    }

    func test_makeRemoteWithLocalFallbackLoader_onRemoteFailure_deliversCachedBooks() {
        let books = [makeBook(), makeBook()]
        let (sut, client, store) = makeSUT()
        store.stubbedBooks = books.map(LocalBookMapper.map)

        expectPublisher(
            sut.makeRemoteWithLocalFallbackLoader(),
            toCompleteWith: .success(books),
            when: {
                client.complete(withError: anyNSError())
            }
        )
    }

    // MARK: - Tests - Remote with Local Fallback Creator
    func test_makeRemoteWithLocalCreator_onSuccessfulRemoteCreate_savesLocally() {
        let book = makeBook()
        let (sut, client, store) = makeSUT()

        let data = encode(BookDTOMapper.map(book))
        expectPublisher(
            sut.makeRemoteWithLocalCreator(item: book),
            toCompleteWith: .success(()),
            when: {
                client.complete(with: data, and: anyHTTPURLResponse())
            }
        )

        XCTAssertEqual(store.savedBooks, [LocalBookMapper.map(book)])
    }

    func test_makeRemoteWithLocalCreator_onRemoteFailure_savesLocally() {
        let book = makeBook()
        let (sut, client, store) = makeSUT()

        expectPublisher(
            sut.makeRemoteWithLocalCreator(item: book),
            toCompleteWith: .success(()),
            when: {
                client.complete(withError: anyNSError())
            }
        )

        XCTAssertEqual(store.savedBooks, [LocalBookMapper.map(book)])
    }

    // MARK: - Tests - Remote with Local Fallback Updater
    func test_makeRemoteWithLocalFallbackUpdater_onSuccessfulRemoteUpdate_updatesLocally() {
        let book = makeBook()
        let (sut, client, store) = makeSUT()

        let data = encode(BookDTOMapper.map(book))
        expectPublisher(
            sut.makeRemoteWithLocalFallbackUpdater(item: book),
            toCompleteWith: .success(()),
            when: {
                client.complete(with: data, and: anyHTTPURLResponse())
            }
        )

        XCTAssertEqual(store.updatedBooks, [LocalBookMapper.map(book)])
    }

    func test_makeRemoteWithLocalFallbackUpdater_onRemoteFailure_updatesLocally() {
        let book = makeBook()
        let (sut, client, store) = makeSUT()

        expectPublisher(
            sut.makeRemoteWithLocalFallbackUpdater(item: book),
            toCompleteWith: .success(()),
            when: {
                client.complete(withError: anyNSError())
            }
        )

        XCTAssertEqual(store.updatedBooks, [LocalBookMapper.map(book)])
    }

    // MARK: - Tests - Remote with Local Fallback Deleter
    func test_makeRemoteWithLocalFallbackDeleter_onSuccessfulRemoteDelete_deletesLocally() {
        let id = UUID()
        let (sut, client, store) = makeSUT()

        expectPublisher(
            sut.makeRemoteWithLocalFallbackDeleter(id: id),
            toCompleteWith: .success(()),
            when: {
                client.complete(with: Data(), and: anyHTTPURLResponse())
            }
        )

        XCTAssertEqual(store.deletedIdentifiers, [id])
    }

    func test_makeRemoteWithLocalFallbackDeleter_onRemoteFailure_deletesLocally() {
        let id = UUID()
        let (sut, client, store) = makeSUT()

        expectPublisher(
            sut.makeRemoteWithLocalFallbackDeleter(id: id),
            toCompleteWith: .success(()),
            when: {
                client.complete(withError: anyNSError())
            }
        )

        XCTAssertEqual(store.deletedIdentifiers, [id])
    }

    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: BookCompositeFactory, client: HTTPClientSpy, store: BookStoreSpy) {
        let client = HTTPClientSpy()
        let store = BookStoreSpy()
        let scheduler = AnyDispatchQueueScheduler.immediateOnMainQueue
        let sut = BookCompositeFactory(client: client, bookStore: AnyStorable(store), scheduler: scheduler)

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, client, store)
    }

    private func makeBook() -> Book {
        Book(
            id: UUID(),
            title: "any title",
            description: "any description",
            author: "any author",
            currentPage: 0,
            numberOfPages: 100,
            coverImage: anyURL(),
            lastReadAt: nil,
            isFavorite: false
        )
    }
}
