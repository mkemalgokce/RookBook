// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import CoreData
import XCTest

final class BookEntityTests: XCTestCase {
    func test_update_updatesAllProperties() throws {
        let (sut, context) = try makeSUT()
        let domain = makeLocalBook()

        try context.throwingPerformAndWait {
            sut.update(with: domain, in: context)
            try context.save()
        }

        XCTAssertEqual(sut.id, domain.id)
        XCTAssertEqual(sut.title, domain.title)
        XCTAssertEqual(sut.author, domain.author)
        XCTAssertEqual(sut.coverURL, domain.coverURL)
        XCTAssertEqual(sut.pageCount, Int16(domain.pageCount))
        XCTAssertEqual(sut.currentPage, Int16(domain.currentPage))
        XCTAssertEqual(sut.lastReadAt, domain.lastReadAt)
        XCTAssertEqual(sut.isFavorite, domain.isFavorite)
        XCTAssertEqual(sut.cacheTimestamp, domain.cacheTimestamp)
    }

    func test_update_handlesOptionalProperties() throws {
        let (sut, context) = try makeSUT()
        let domain = makeLocalBook(coverURL: nil, lastReadAt: nil)

        try context.throwingPerformAndWait {
            sut.update(with: domain, in: context)
            try context.save()
        }

        XCTAssertNil(sut.coverURL)
        XCTAssertNil(sut.lastReadAt)
    }

    func test_toLocal_convertsToLocalBook() throws {
        let (sut, context) = try makeSUT()
        let expectedBook = makeLocalBook()

        try context.throwingPerformAndWait {
            sut.update(with: expectedBook, in: context)
            try context.save()
        }

        let localBook = sut.toLocal()

        XCTAssertEqual(localBook.id, expectedBook.id)
        XCTAssertEqual(localBook.title, expectedBook.title)
        XCTAssertEqual(localBook.author, expectedBook.author)
        XCTAssertEqual(localBook.coverURL, expectedBook.coverURL)
        XCTAssertEqual(localBook.pageCount, expectedBook.pageCount)
        XCTAssertEqual(localBook.currentPage, expectedBook.currentPage)
        XCTAssertEqual(localBook.lastReadAt, expectedBook.lastReadAt)
        XCTAssertEqual(localBook.isFavorite, expectedBook.isFavorite)
        XCTAssertEqual(localBook.cacheTimestamp, expectedBook.cacheTimestamp)
    }

    func test_toLocal_handlesOptionalProperties() throws {
        let (sut, context) = try makeSUT()
        let expectedBook = makeLocalBook(coverURL: nil, lastReadAt: nil)

        try context.throwingPerformAndWait {
            sut.update(with: expectedBook, in: context)
            try context.save()
        }

        let localBook = sut.toLocal()

        XCTAssertNil(localBook.coverURL)
        XCTAssertNil(localBook.lastReadAt)
    }

    func test_roundTrip_maintainsDataIntegrity() throws {
        let (sut, context) = try makeSUT()
        let originalBook = makeLocalBook()

        try context.throwingPerformAndWait {
            sut.update(with: originalBook, in: context)
            try context.save()
        }

        let roundTripBook = sut.toLocal()

        XCTAssertEqual(roundTripBook.id, originalBook.id)
        XCTAssertEqual(roundTripBook.title, originalBook.title)
        XCTAssertEqual(roundTripBook.author, originalBook.author)
        XCTAssertEqual(roundTripBook.coverURL, originalBook.coverURL)
        XCTAssertEqual(roundTripBook.pageCount, originalBook.pageCount)
        XCTAssertEqual(roundTripBook.currentPage, originalBook.currentPage)
        XCTAssertEqual(roundTripBook.lastReadAt, originalBook.lastReadAt)
        XCTAssertEqual(roundTripBook.isFavorite, originalBook.isFavorite)
        XCTAssertEqual(roundTripBook.cacheTimestamp, originalBook.cacheTimestamp)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file,
                         line: UInt = #line) throws -> (BookEntity, NSManagedObjectContext) {
        let (context, container) = makeContext(file: file, line: line)
        var sut: BookEntity!
        try context.throwingPerformAndWait {
            sut = BookEntity(context: context)
        }

        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, context)
    }

    private func makeContext(file: StaticString = #file,
                             line: UInt = #line) -> (NSManagedObjectContext, NSPersistentContainer) {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let managedObjectModel = NSManagedObjectModel.with(name: "BookStore", in: Bundle(for: BookEntity.self))!
        let container = try! NSPersistentContainer.load(name: "BookStore", model: managedObjectModel, url: storeURL)
        let context = container.newBackgroundContext()
        return (context, container)
    }

    private func makeLocalBook(
        id: UUID = UUID(),
        title: String = "Test Title",
        author: String = "Test Author",
        coverURL: URL? = URL(string: "https://example.com/cover.jpg"),
        pageCount: Int = 100,
        currentPage: Int = 42,
        lastReadAt: Date? = Date(),
        isFavorite: Bool = true,
        cacheTimestamp: Date = Date()
    ) -> LocalBook {
        LocalBook(
            id: id,
            title: title,
            author: author,
            coverURL: coverURL,
            pageCount: pageCount,
            currentPage: currentPage,
            lastReadAt: lastReadAt,
            isFavorite: isFavorite,
            cacheTimestamp: cacheTimestamp
        )
    }
}
