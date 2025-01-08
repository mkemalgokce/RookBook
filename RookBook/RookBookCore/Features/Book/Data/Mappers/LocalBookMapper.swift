// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

enum LocalBookMapper {
    // MARK: - Static Methods
    static func map(_ book: Book) -> LocalBook {
        LocalBook(
            id: book.id,
            title: book.title,
            description: book.description,
            author: book.author,
            coverURL: book.coverImage,
            pageCount: book.numberOfPages,
            currentPage: book.currentPage,
            lastReadAt: book.lastReadAt,
            isFavorite: book.isFavorite
        )
    }

    static func map(_ localBook: LocalBook) -> Book {
        Book(
            id: localBook.id,
            title: localBook.title,
            description: localBook.description,
            author: localBook.author,
            currentPage: localBook.currentPage,
            numberOfPages: localBook.pageCount,
            coverImage: localBook.coverURL,
            lastReadAt: localBook.lastReadAt,
            isFavorite: localBook.isFavorite
        )
    }

    static func map(_ localBooks: [LocalBook]) -> [Book] {
        localBooks.map { map($0) }
    }

    static func map(_ books: [Book]) -> [LocalBook] {
        books.map { map($0) }
    }
}
