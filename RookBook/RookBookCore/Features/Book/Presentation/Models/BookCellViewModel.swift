// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

public struct BookCellViewModel {
    // MARK: - Properties
    public let name: String
    public let description: String
    public let author: String

    // MARK: - Initializers
    public init(name: String, description: String, author: String) {
        self.name = name
        self.description = description
        self.author = author
    }
}
