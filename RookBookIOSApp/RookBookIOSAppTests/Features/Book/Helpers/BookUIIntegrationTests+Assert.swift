// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import RookBookIOS
import XCTest

extension BookUIIntegrationTests {
    func assertThat(
        _ sut: BookViewController,
        isRendering book: [Book],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        sut.view.enforceLayoutCycle()
        guard sut.numberOfRenderedCells() == book.count else {
            return XCTFail(
                "Expected \(book.count) books, got \(sut.numberOfRenderedCells()) instead.",
                file: file,
                line: line
            )
        }

        book.enumerated().forEach { index, book in
            assertThat(sut, hasViewConfiguredFor: book, at: index, file: file, line: line)
        }

        executeRunLoopToCleanUpReferences()
    }

    func assertThat(
        _ sut: BookViewController,
        hasViewConfiguredFor book: Book,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.resource(at: index)
        guard let cell = view as? BookCell else {
            return XCTFail(
                "Expected BookCell at index \(index) but found \(String(describing: view))",
                file: file,
                line: line
            )
        }

        XCTAssertEqual(
            cell.nameText,
            book.title,
            "Expected title text to be \(book.title) but found \(String(describing: cell.nameText))",
            file: file,
            line: line
        )

        XCTAssertEqual(
            cell.descriptionText,
            book.description,
            "Expected description text to be \(book.description) but found \(String(describing: cell.descriptionText))",
            file: file,
            line: line
        )

        XCTAssertEqual(
            cell.authorText,
            book.author,
            "Expected author text to be \(String(describing: book.author)) but found \(String(describing: cell.authorText))",
            file: file,
            line: line
        )
    }

    func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
