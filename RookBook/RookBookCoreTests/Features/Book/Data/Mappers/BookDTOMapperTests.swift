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
        XCTAssertEqual(book.numberOfPages, dto.totalPages)
        XCTAssertEqual(book.coverImage, dto.coverUrl)
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
        XCTAssertEqual(dto.totalPages, book.numberOfPages)
        XCTAssertEqual(dto.coverUrl, book.coverImage)
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
        XCTAssertEqual(resultDTO.totalPages, originalDTO.totalPages)
        XCTAssertEqual(resultDTO.coverUrl, originalDTO.coverUrl)
    }

    // MARK: - Helpers
    private func makeBookDTO(
        id: UUID = UUID(),
        title: String = "any title",
        description: String = "any description",
        author: String = "any author",
        currentPage: Int = 0,
        pageCount: Int = 100,
        coverURL: URL? = anyURL()
    ) -> BookDTO {
        BookDTO(
            id: id,
            title: title,
            description: description,
            author: author,
            totalPages: pageCount,
            coverUrl: coverURL,
            currentPage: currentPage,
            lastReadAt: nil
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
