// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

public enum BookCellPresenter {
    public static func map(_ book: Book) -> BookCellViewModel {
        BookCellViewModel(name: book.title, description: book.description, author: book.author)
    }
}
