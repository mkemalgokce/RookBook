// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct LocalBook: Codable, StorableItem, Cacheable, Hashable {
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let description: String?
    public let author: String
    public let coverURL: URL?
    public let pageCount: Int
    public let currentPage: Int
    public let lastReadAt: Date?
    public let isFavorite: Bool
    public let cacheTimestamp: Date

    // MARK: - Initializers
    public init(
        id: UUID,
        title: String,
        description: String?,
        author: String,
        coverURL: URL?,
        pageCount: Int,
        currentPage: Int,
        lastReadAt: Date?,
        isFavorite: Bool,
        cacheTimestamp: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.coverURL = coverURL
        self.pageCount = pageCount
        self.currentPage = currentPage
        self.lastReadAt = lastReadAt
        self.isFavorite = isFavorite
        self.cacheTimestamp = cacheTimestamp
    }

    public static func ==(lhs: LocalBook, rhs: LocalBook) -> Bool {
        lhs.id == rhs.id
    }
}
