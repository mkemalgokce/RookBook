// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct EmailSignInCredentials: SignInCredentials, Equatable {
    // MARK: - Properties
    public let email: String
    public let password: String

    // MARK: - Initializers
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    // MARK: - Public Methods
    public func toStringDictionary() -> [String: Any?] {
        [
            "email": email,
            "password": password
        ]
    }
}
