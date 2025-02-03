// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct BookDTO: Codable {
    public let id: UUID
    public let title: String
    public let description: String?
    public let author: String
    public let totalPages: Int
    public let coverUrl: URL?
    public let currentPage: Int?
    public let lastReadAt: String?

    public init(
        id: UUID,
        title: String,
        description: String?,
        author: String,
        totalPages: Int,
        coverUrl: URL?,
        currentPage: Int?,
        lastReadAt: String?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.totalPages = totalPages
        self.coverUrl = coverUrl
        self.currentPage = currentPage
        self.lastReadAt = lastReadAt
    }
}

public struct BookResponse: Codable {
    public let items: [BookDTO]
}
