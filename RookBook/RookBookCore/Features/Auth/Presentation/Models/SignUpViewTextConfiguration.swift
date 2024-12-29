// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct SignUpViewTextConfiguration {
    public let title: String
    public let fullNameTextFieldPlaceholder: String
    public let emailTextFieldPlaceholder: String
    public let passwordTextFieldPlaceholder: String
    public let signUpButtonTitle: String
    public let signUpWithAppleButtonTitle: String
    public let alreadyHaveAccountButtonTitle: String
    public let signInButtonTitle: String

    public init(
        title: String,
        fullNameTextFieldPlaceholder: String,
        emailTextFieldPlaceholder: String,
        passwordTextFieldPlaceholder: String,
        signUpButtonTitle: String,
        signUpWithAppleButtonTitle: String,
        alreadyHaveAccountButtonTitle: String,
        signInButtonTitle: String
    ) {
        self.title = title
        self.fullNameTextFieldPlaceholder = fullNameTextFieldPlaceholder
        self.emailTextFieldPlaceholder = emailTextFieldPlaceholder
        self.passwordTextFieldPlaceholder = passwordTextFieldPlaceholder
        self.signUpButtonTitle = signUpButtonTitle
        self.signUpWithAppleButtonTitle = signUpWithAppleButtonTitle
        self.alreadyHaveAccountButtonTitle = alreadyHaveAccountButtonTitle
        self.signInButtonTitle = signInButtonTitle
    }
}
