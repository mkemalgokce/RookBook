// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct CachedBook: Codable, StorableItem, Cacheable {
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let author: String
    public let coverURL: URL
    public let pageCount: Int
    public let currentPage: Int
    public let lastReadAt: Date?
    public let isFavorite: Bool

    // MARK: - Initializers
    public init(
        id: UUID,
        title: String,
        author: String,
        coverURL: URL,
        pageCount: Int,
        currentPage: Int,
        lastReadAt: Date?,
        isFavorite: Bool
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.coverURL = coverURL
        self.pageCount = pageCount
        self.currentPage = currentPage
        self.lastReadAt = lastReadAt
        self.isFavorite = isFavorite
    }

    public init(_ book: Book) {
        self.init(
            id: book.id,
            title: book.title,
            author: book.author,
            coverURL: book.coverImage,
            pageCount: book.numberOfPages,
            currentPage: book.currentPage,
            lastReadAt: book.lastReadAt,
            isFavorite: book.isFavorite
        )
    }
}
