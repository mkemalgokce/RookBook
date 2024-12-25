// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public struct AuthenticatedUser: User, Decodable {
    // MARK: - Properties
    public let id: String
    public let email: String?
    public let name: String?

    // MARK: - Initializers
    public init(
        id: String,
        email: String?,
        name: String?,
        accessToken: String,
        refreshToken: String?
    ) {
        self.id = id
        self.email = email
        self.name = name
    }

    // MARK: - Public Methods
    public func toStringDictionary() -> [String: Any?] {
        [
            "id": id,
            "email": email,
            "name": name
        ]
    }
}
