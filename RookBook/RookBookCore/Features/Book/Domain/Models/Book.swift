import Foundation

public struct Book: Hashable, Identifiable {
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let description: String
    public let author: String
    public let currentPage: Int
    public let numberOfPages: Int
    public let coverImage: URL
    
    // MARK: - Initializers
    public init(
        id: UUID,
        title: String,
        description: String,
        author: String,
        currentPage: Int,
        numberOfPages: Int,
        coverImage: URL
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.currentPage = currentPage
        self.numberOfPages = numberOfPages
        self.coverImage = coverImage
    }
} 
