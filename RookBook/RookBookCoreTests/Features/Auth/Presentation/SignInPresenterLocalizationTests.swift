// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class SignInPresenterLocalizationTests: XCTestCase {
    private let table = "SignIn"
    private let bundle = Bundle(for: SignInPresenter.self)

    func test_localizedProperties_haveKeysAndValuesForAllSupportedLocales() {
        assertAllLocalizedKeysAndValuesExist(in: bundle, table)
    }

    func test_localizedProperties_returnsCorrectValues() {
        assertPropertyMatchesLocalizedString(
            SignInPresenter.title,
            key: "Sign In Title",
            table: table,
            bundle: bundle
        )
        assertPropertyMatchesLocalizedString(
            SignInPresenter.emailPlaceholder,
            key: "Email Placeholder",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignInPresenter.passwordPlaceholder,
            key: "Password Placeholder",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignInPresenter.signInButtonTitle,
            key: "Sign In Button Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignInPresenter.signInWithAppleButtonTitle,
            key: "Sign In With Apple Button Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignInPresenter.dontHaveAnAccountTitle,
            key: "Don't Have An Account Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignInPresenter.signUpButtonTitle,
            key: "Sign Up Button Title",
            table: table,
            bundle: bundle
        )
    }
}
