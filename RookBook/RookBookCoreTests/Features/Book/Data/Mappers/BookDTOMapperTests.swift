// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class BookDTOMapperTests: XCTestCase {
    func test_map_convertsBookDTOToBook() {
        let dto = makeBookDTO()

        let book = BookDTOMapper.map(dto)

        XCTAssertEqual(book.id, dto.id)
        XCTAssertEqual(book.title, dto.title)
        XCTAssertEqual(book.description, dto.description)
        XCTAssertEqual(book.author, dto.author)
        XCTAssertEqual(book.numberOfPages, dto.pageCount)
        XCTAssertEqual(book.coverImage, dto.coverURL)
        XCTAssertEqual(book.currentPage, 0)
        XCTAssertNil(book.lastReadAt)
        XCTAssertFalse(book.isFavorite)
    }

    func test_map_convertsBookToBookDTO() {
        let book = makeBook()

        let dto = BookDTOMapper.map(book)

        XCTAssertEqual(dto.id, book.id)
        XCTAssertEqual(dto.title, book.title)
        XCTAssertEqual(dto.description, book.description)
        XCTAssertEqual(dto.author, book.author)
        XCTAssertEqual(dto.pageCount, book.numberOfPages)
        XCTAssertEqual(dto.coverURL, book.coverImage)
    }

    func test_map_handlesOptionalValues() {
        let dto = makeBookDTO(coverURL: nil)

        let book = BookDTOMapper.map(dto)

        XCTAssertNil(book.coverImage)
    }

    func test_map_maintainsDataIntegrity_withRoundTrip() {
        let originalDTO = makeBookDTO()

        let book = BookDTOMapper.map(originalDTO)
        let resultDTO = BookDTOMapper.map(book)

        XCTAssertEqual(resultDTO.id, originalDTO.id)
        XCTAssertEqual(resultDTO.title, originalDTO.title)
        XCTAssertEqual(resultDTO.description, originalDTO.description)
        XCTAssertEqual(resultDTO.author, originalDTO.author)
        XCTAssertEqual(resultDTO.pageCount, originalDTO.pageCount)
        XCTAssertEqual(resultDTO.coverURL, originalDTO.coverURL)
    }

    // MARK: - Helpers
    private func makeBookDTO(
        id: UUID = UUID(),
        title: String = "any title",
        description: String = "any description",
        author: String = "any author",
        pageCount: Int = 100,
        coverURL: URL? = anyURL()
    ) -> BookDTO {
        BookDTO(
            id: id,
            title: title,
            description: description,
            author: author,
            pageCount: pageCount,
            coverURL: coverURL
        )
    }

    private func makeBook(
        id: UUID = UUID(),
        title: String = "any title",
        description: String = "any description",
        author: String = "any author",
        currentPage: Int = 0,
        numberOfPages: Int = 100,
        coverImage: URL? = anyURL(),
        lastReadAt: Date? = nil,
        isFavorite: Bool = false
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
}
