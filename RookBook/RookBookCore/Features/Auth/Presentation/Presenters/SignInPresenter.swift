// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public final class SignInPresenter {
    // MARK: - Static Properties
    public static var title: String {
        NSLocalizedString("Sign In Title",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Sign In Title")
    }

    public static var emailPlaceholder: String {
        NSLocalizedString("Email Placeholder",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Email Placeholder")
    }

    public static var passwordPlaceholder: String {
        NSLocalizedString("Password Placeholder",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Password Placeholder")
    }

    public static var signInButtonTitle: String {
        NSLocalizedString("Sign In Button Title",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Sign In Button Title")
    }

    public static var signInWithAppleButtonTitle: String {
        NSLocalizedString("Sign In With Apple Button Title",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Sign In With Apple Button Title")
    }

    public static var dontHaveAnAccountTitle: String {
        NSLocalizedString("Don't Have An Account Title",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Don't Have An Account Title")
    }

    public static var signUpButtonTitle: String {
        NSLocalizedString("Sign Up Button Title",
                          tableName: "SignIn",
                          bundle: Bundle(for: self),
                          comment: "Sign Up Button Title")
    }

    public static var textConfiguration: SignInViewTextConfiguration {
        SignInViewTextConfiguration(title: title,
                                    emailPlaceholder: emailPlaceholder,
                                    passwordPlaceholder: passwordPlaceholder,
                                    signInButtonTitle: signInButtonTitle,
                                    signInWithAppleButtonTitle: signInWithAppleButtonTitle,
                                    signUpButtonTitle: signUpButtonTitle,
                                    dontHaveAccountText: dontHaveAnAccountTitle)
    }
}
