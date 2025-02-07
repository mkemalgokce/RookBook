// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class SignUpPresenterLocalizationTests: XCTestCase {
    private let table = "SignUp"
    private let bundle = Bundle(for: SignUpPresenter.self)

    func test_localizedProperties_haveKeysAndValuesForAllSupportedLocales() {
        assertAllLocalizedKeysAndValuesExist(in: bundle, table)
    }

    func test_localizedProperties_returnsCorrectValues() {
        assertPropertyMatchesLocalizedString(
            SignUpPresenter.title,
            key: "Sign Up Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.fullNamePlaceholder,
            key: "Full Name Placeholder",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.emailPlaceholder,
            key: "Email Placeholder",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.passwordPlaceholder,
            key: "Password Placeholder",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.signUpButtonTitle,
            key: "Sign Up Button Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.signUpWithAppleButtonTitle,
            key: "Sign Up With Apple Button Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.alreadyHaveAnAccountTitle,
            key: "Already Have An Account Title",
            table: table,
            bundle: bundle
        )

        assertPropertyMatchesLocalizedString(
            SignUpPresenter.signInButtonTitle,
            key: "Sign In Button Title",
            table: table,
            bundle: bundle
        )
    }

    func test_testConfiguration_returnsCorrectValues() {
        let configuration = SignUpPresenter.textConfiguration

        XCTAssertEqual(configuration.title, SignUpPresenter.title)
        XCTAssertEqual(configuration.fullNameTextFieldPlaceholder, SignUpPresenter.fullNamePlaceholder)
        XCTAssertEqual(configuration.emailTextFieldPlaceholder, SignUpPresenter.emailPlaceholder)
        XCTAssertEqual(configuration.passwordTextFieldPlaceholder, SignUpPresenter.passwordPlaceholder)
        XCTAssertEqual(configuration.signUpButtonTitle, SignUpPresenter.signUpButtonTitle)
        XCTAssertEqual(configuration.signUpWithAppleButtonTitle, SignUpPresenter.signUpWithAppleButtonTitle)
        XCTAssertEqual(configuration.alreadyHaveAccountButtonTitle, SignUpPresenter.alreadyHaveAnAccountTitle)
        XCTAssertEqual(configuration.signInButtonTitle, SignUpPresenter.signInButtonTitle)
    }
}
