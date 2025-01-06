@testable import RookBookCore
// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.
import XCTest

final class LocalBookMapperTests: XCTestCase {
    func test_map_convertsBookToLocalBook() {
        let book = makeBook()

        let localBook = LocalBookMapper.map(book)

        XCTAssertEqual(localBook.id, book.id)
        XCTAssertEqual(localBook.title, book.title)
        XCTAssertEqual(localBook.author, book.author)
        XCTAssertEqual(localBook.coverURL, book.coverImage)
        XCTAssertEqual(localBook.pageCount, book.numberOfPages)
        XCTAssertEqual(localBook.currentPage, book.currentPage)
        XCTAssertEqual(localBook.lastReadAt, book.lastReadAt)
        XCTAssertEqual(localBook.isFavorite, book.isFavorite)
    }

    func test_map_convertsLocalBookToBook() {
        let localBook = makeLocalBook()

        let book = LocalBookMapper.map(localBook)

        XCTAssertEqual(book.id, localBook.id)
        XCTAssertEqual(book.title, localBook.title)
        XCTAssertEqual(book.author, localBook.author)
        XCTAssertEqual(book.coverImage, localBook.coverURL)
        XCTAssertEqual(book.numberOfPages, localBook.pageCount)
        XCTAssertEqual(book.currentPage, localBook.currentPage)
        XCTAssertEqual(book.lastReadAt, localBook.lastReadAt)
        XCTAssertEqual(book.isFavorite, localBook.isFavorite)
        XCTAssertEqual(book.description, "")
    }

    func test_map_maintainsDataIntegrityInRoundTrip() {
        let originalBook = makeBook()

        let localBook = LocalBookMapper.map(originalBook)
        let roundTripBook = LocalBookMapper.map(localBook)

        XCTAssertEqual(roundTripBook.id, originalBook.id)
        XCTAssertEqual(roundTripBook.title, originalBook.title)
        XCTAssertEqual(roundTripBook.author, originalBook.author)
        XCTAssertEqual(roundTripBook.coverImage, originalBook.coverImage)
        XCTAssertEqual(roundTripBook.numberOfPages, originalBook.numberOfPages)
        XCTAssertEqual(roundTripBook.currentPage, originalBook.currentPage)
        XCTAssertEqual(roundTripBook.lastReadAt, originalBook.lastReadAt)
        XCTAssertEqual(roundTripBook.isFavorite, originalBook.isFavorite)
        XCTAssertEqual(roundTripBook.description, "")
    }

    // MARK: - Helpers
    private func makeBook(
        id: UUID = UUID(),
        title: String = "Test Title",
        description: String = "Test Description",
        author: String = "Test Author",
        currentPage: Int = 42,
        numberOfPages: Int = 100,
        coverImage: URL = URL(string: "https://example.com/cover.jpg")!,
        lastReadAt: Date = Date(),
        isFavorite: Bool = true
    ) -> Book {
        Book(
            id: id,
            title: title,
            description: description,
            author: author,
            currentPage: currentPage,
            numberOfPages: numberOfPages,
            coverImage: coverImage,
            lastReadAt: lastReadAt,
            isFavorite: isFavorite
        )
    }

    private func makeLocalBook(
        id: UUID = UUID(),
        title: String = "Test Title",
        author: String = "Test Author",
        coverURL: URL = URL(string: "https://example.com/cover.jpg")!,
        pageCount: Int = 100,
        currentPage: Int = 42,
        lastReadAt: Date = Date(),
        isFavorite: Bool = true
    ) -> LocalBook {
        LocalBook(
            id: id,
            title: title,
            author: author,
            coverURL: coverURL,
            pageCount: pageCount,
            currentPage: currentPage,
            lastReadAt: lastReadAt,
            isFavorite: isFavorite
        )
    }
}
