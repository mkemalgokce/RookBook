// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class BookListPresenterLocalizationTests: XCTestCase {
    private let table = "BookList"
    private let bundle = Bundle(for: BookListPresenter.self)

    func test_localizedProperties_haveKeysAndValuesForAllSupportedLocales() {
        assertAllLocalizedKeysAndValuesExist(in: bundle, table)
    }

    func test_localizedProperties_returnsCorrectValues() {
        assertPropertyMatchesLocalizedString(
            BookListPresenter.title,
            key: "Book List Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            BookListPresenter.emptyMessage,
            key: "Book List Empty Message",
            table: table,
            bundle: bundle
        )
    }

    func test_textConfiguration_returnsCorrectValues() {
        let textConfiguration = BookListPresenter.textConfiguration

        XCTAssertEqual(textConfiguration.title, BookListPresenter.title)
        XCTAssertEqual(textConfiguration.emptyMessage, BookListPresenter.emptyMessage)
    }
}
