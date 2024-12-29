// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct EmailSignUpCredentials: SignUpCredentials, Hashable {
    // MARK: - Properties
    public let name: String
    public let email: String
    public let password: String

    // MARK: - Initializers
    public init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }

    // MARK: - Public Methods
    public func toStringDictionary() -> [String: Any?] {
        [
            "name": name,
            "email": email,
            "password": password
        ]
    }
}
