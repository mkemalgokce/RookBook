// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.
@testable import RookBookCore
import XCTest

final class LocalBookMapperTests: XCTestCase {
    // MARK: - Single Item Mapping Tests
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
        XCTAssertEqual(book.description, localBook.description)
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
        XCTAssertEqual(roundTripBook.description, originalBook.description)
    }

    // MARK: - Array Mapping Tests
    func test_map_convertsBookArrayToLocalBookArray() {
        let books = [makeBook(), makeBook(id: UUID(), title: "Another Book")]

        let localBooks = LocalBookMapper.map(books)

        XCTAssertEqual(localBooks.count, books.count)
        for (localBook, book) in zip(localBooks, books) {
            XCTAssertEqual(localBook.id, book.id)
            XCTAssertEqual(localBook.title, book.title)
            XCTAssertEqual(localBook.author, book.author)
            XCTAssertEqual(localBook.coverURL, book.coverImage)
            XCTAssertEqual(localBook.pageCount, book.numberOfPages)
            XCTAssertEqual(localBook.currentPage, book.currentPage)
            XCTAssertEqual(localBook.lastReadAt, book.lastReadAt)
            XCTAssertEqual(localBook.isFavorite, book.isFavorite)
            XCTAssertEqual(localBook.description, book.description)
        }
    }

    func test_map_convertsLocalBookArrayToBookArray() {
        let localBooks = [makeLocalBook(), makeLocalBook(id: UUID(), title: "Another Book")]

        let books = LocalBookMapper.map(localBooks)

        XCTAssertEqual(books.count, localBooks.count)
        for (book, localBook) in zip(books, localBooks) {
            XCTAssertEqual(book.id, localBook.id)
            XCTAssertEqual(book.title, localBook.title)
            XCTAssertEqual(book.author, localBook.author)
            XCTAssertEqual(book.coverImage, localBook.coverURL)
            XCTAssertEqual(book.numberOfPages, localBook.pageCount)
            XCTAssertEqual(book.currentPage, localBook.currentPage)
            XCTAssertEqual(book.lastReadAt, localBook.lastReadAt)
            XCTAssertEqual(book.isFavorite, localBook.isFavorite)
            XCTAssertEqual(book.description, localBook.description)
        }
    }

    func test_map_maintainsDataIntegrityInArrayRoundTrip() {
        let originalBooks = [makeBook(), makeBook(id: UUID(), title: "Another Book")]

        let localBooks = LocalBookMapper.map(originalBooks)
        let roundTripBooks = LocalBookMapper.map(localBooks)

        XCTAssertEqual(roundTripBooks.count, originalBooks.count)
        for (roundTripBook, originalBook) in zip(roundTripBooks, originalBooks) {
            XCTAssertEqual(roundTripBook.id, originalBook.id)
            XCTAssertEqual(roundTripBook.title, originalBook.title)
            XCTAssertEqual(roundTripBook.author, originalBook.author)
            XCTAssertEqual(roundTripBook.coverImage, originalBook.coverImage)
            XCTAssertEqual(roundTripBook.numberOfPages, originalBook.numberOfPages)
            XCTAssertEqual(roundTripBook.currentPage, originalBook.currentPage)
            XCTAssertEqual(roundTripBook.lastReadAt, originalBook.lastReadAt)
            XCTAssertEqual(roundTripBook.isFavorite, originalBook.isFavorite)
            XCTAssertEqual(roundTripBook.description, originalBook.description)
        }
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
        description: String = "Test Description",
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
            description: description,
            author: author,
            coverURL: coverURL,
            pageCount: pageCount,
            currentPage: currentPage,
            lastReadAt: lastReadAt,
            isFavorite: isFavorite
        )
    }
}
