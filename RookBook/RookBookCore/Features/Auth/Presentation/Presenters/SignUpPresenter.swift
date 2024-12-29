// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public final class SignUpPresenter {
    // MARK: - Static Properties
    public static var title: String {
        NSLocalizedString("Sign Up Title",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Sign Up Title")
    }

    public static var fullNamePlaceholder: String {
        NSLocalizedString("Full Name Placeholder",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Full Name Placeholder")
    }

    public static var emailPlaceholder: String {
        NSLocalizedString("Email Placeholder",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Email Placeholder")
    }

    public static var passwordPlaceholder: String {
        NSLocalizedString("Password Placeholder",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Password Placeholder")
    }

    public static var signUpButtonTitle: String {
        NSLocalizedString("Sign Up Button Title",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Sign Up Button Title")
    }

    public static var signUpWithAppleButtonTitle: String {
        NSLocalizedString("Sign Up With Apple Button Title",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Sign Up With Apple Button Title")
    }

    public static var alreadyHaveAnAccountTitle: String {
        NSLocalizedString("Already Have An Account Title",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Already Have An Account Title")
    }

    public static var signInButtonTitle: String {
        NSLocalizedString("Sign In Button Title",
                          tableName: "SignUp",
                          bundle: Bundle(for: self),
                          comment: "Sign In Button Title")
    }

    public static var textConfiguration: SignUpViewTextConfiguration {
        SignUpViewTextConfiguration(
            title: title,
            fullNameTextFieldPlaceholder: fullNamePlaceholder,
            emailTextFieldPlaceholder: emailPlaceholder,
            passwordTextFieldPlaceholder: passwordPlaceholder,
            signUpButtonTitle: signUpButtonTitle,
            signUpWithAppleButtonTitle: signUpWithAppleButtonTitle,
            alreadyHaveAccountButtonTitle: alreadyHaveAnAccountTitle,
            signInButtonTitle: signInButtonTitle
        )
    }
}
