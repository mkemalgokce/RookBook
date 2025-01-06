// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct BookDTO: Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let author: String
    public let pageCount: Int
    public let coverURL: URL?

    public init(
        id: UUID,
        title: String,
        description: String,
        author: String,
        pageCount: Int,
        coverURL: URL?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.pageCount = pageCount
        self.coverURL = coverURL
    }
}
