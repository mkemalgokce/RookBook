// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class BookCellPresenterTests: XCTestCase {
    func test_map_deliversViewModelWithCorrectValues() {
        let book = makeBook()

        let expectedViewModel = BookCellViewModel(name: book.title,
                                                  description: book.description,
                                                  author: book.author)

        let viewModel = BookCellPresenter.map(book)

        XCTAssertEqual(viewModel.name, expectedViewModel.name)
        XCTAssertEqual(viewModel.description, expectedViewModel.description)
        XCTAssertEqual(viewModel.author, expectedViewModel.author)
    }
}
