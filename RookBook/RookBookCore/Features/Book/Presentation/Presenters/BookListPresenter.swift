// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public final class BookListPresenter {
    // MARK: - Static Properties
    public static var title: String {
        NSLocalizedString("Book List Title",
                          tableName: "BookList",
                          bundle: Bundle(for: self),
                          comment: "Book Title")
    }

    public static var emptyMessage: String {
        NSLocalizedString("Book List Empty Message",
                          tableName: "BookList",
                          bundle: Bundle(for: self),
                          comment: "Book Empty Message")
    }

    public static var textConfiguration: BookListViewTextConfiguration {
        BookListViewTextConfiguration(
            title: title,
            emptyMessage: emptyMessage
        )
    }
}
