// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct SignInViewTextConfiguration {
    // MARK: - Properties
    public let title: String
    public let emailPlaceholder: String
    public let passwordPlaceholder: String
    public let signInButtonTitle: String
    public let signInWithAppleButtonTitle: String
    public let signUpButtonTitle: String
    public let dontHaveAccountText: String

    // MARK: - Initializers
    public init(
        title: String,
        emailPlaceholder: String,
        passwordPlaceholder: String,
        signInButtonTitle: String,
        signInWithAppleButtonTitle: String,
        signUpButtonTitle: String,
        dontHaveAccountText: String
    ) {
        self.title = title
        self.emailPlaceholder = emailPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.signInButtonTitle = signInButtonTitle
        self.signInWithAppleButtonTitle = signInWithAppleButtonTitle
        self.signUpButtonTitle = signUpButtonTitle
        self.dontHaveAccountText = dontHaveAccountText
    }
}
