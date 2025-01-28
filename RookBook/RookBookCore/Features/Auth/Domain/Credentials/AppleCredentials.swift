// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct AppleCredentials: SignInCredentials, SignUpCredentials, Hashable {
    // MARK: - Properties
    let userIdentifier: String
    let email: String?
    let fullName: String?
    let authorizationCode: Data?
    let identityToken: Data?

    // MARK: - Initializers
    public init(
        userIdentifier: String,
        email: String?,
        fullName: String?,
        authorizationCode: Data?,
        identityToken: Data?
    ) {
        self.userIdentifier = userIdentifier
        self.email = email
        self.fullName = fullName
        self.authorizationCode = authorizationCode
        self.identityToken = identityToken
    }

    // MARK: - Public Methods
    public func toStringDictionary() -> [String: Any?] {
        ["userIdentifier": userIdentifier,
         "email": email,
         "fullName": fullName,
         "authorizationCode": authorizationCode?.base64EncodedString(),
         "identityToken": identityToken?.base64EncodedString()]
    }
}
