import Foundation

public struct Book: Hashable, Identifiable {
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let description: String
    public let author: String
    public let currentPage: Int
    public let numberOfPages: Int
    public let coverImage: URL?
    public let lastReadAt: Date?
    public let isFavorite: Bool

    // MARK: - Initializers
    public init(
        id: UUID,
        title: String,
        description: String,
        author: String,
        currentPage: Int,
        numberOfPages: Int,
        coverImage: URL?,
        lastReadAt: Date?,
        isFavorite: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.currentPage = currentPage
        self.numberOfPages = numberOfPages
        self.coverImage = coverImage
        self.lastReadAt = lastReadAt
        self.isFavorite = isFavorite
    }
}
