// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

enum BookDTOMapper {
    static func map(_ dto: BookDTO) -> Book {
        Book(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            author: dto.author,
            currentPage: 0,
            numberOfPages: dto.totalPages,
            coverImage: dto.coverUrl,
            lastReadAt: nil,
            isFavorite: false
        )
    }

    static func map(_ book: Book) -> BookDTO {
        BookDTO(
            id: book.id,
            title: book.title,
            description: book.description,
            author: book.author,
            totalPages: book.numberOfPages,
            coverUrl: book.coverImage,
            currentPage: nil,
            lastReadAt: nil
        )
    }
}
