// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public struct AuthenticatedUser: Equatable {
    // MARK: - Properties
    public let id: String
    public let email: String?
    public let name: String?

    // MARK: - Initializers
    public init(
        id: String,
        email: String?,
        name: String?
    ) {
        self.id = id
        self.email = email
        self.name = name
    }
}
