// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
@testable import RookBookIOSApp
import XCTest

final class SignUpUIIntegrationTests: XCTestCase {
    // MARK: - UI Configuration Tests
    func test_viewDidLoad_configuresViewWithCorrectTexts() {
        let (sut, _) = makeSUT()
        sut.simulateAppearance()

        XCTAssertEqual(sut.title, SignUpPresenter.textConfiguration.title)
        XCTAssertEqual(
            sut.rootView.fullNameTextField.placeholder,
            SignUpPresenter.textConfiguration.fullNameTextFieldPlaceholder
        )
        XCTAssertEqual(
            sut.rootView.mailTextField.placeholder,
            SignUpPresenter.textConfiguration.emailTextFieldPlaceholder
        )
        XCTAssertEqual(
            sut.rootView.passTextField.placeholder,
            SignUpPresenter.textConfiguration.passwordTextFieldPlaceholder
        )
        XCTAssertEqual(
            sut.rootView.signUpButton.title(for: .normal),
            SignUpPresenter.textConfiguration.signUpButtonTitle
        )
        XCTAssertEqual(
            sut.rootView.signUpWithAppleButton.title(for: .normal),
            SignUpPresenter.textConfiguration.signUpWithAppleButtonTitle
        )
        XCTAssertEqual(sut.rootView.signInButton.attributedTitle(for: .normal)?.string,
                       SignUpPresenter.textConfiguration.alreadyHaveAccountButtonTitle + " " + SignUpPresenter
                           .textConfiguration.signInButtonTitle)
    }

    // MARK: - Email Sign Up Tests
    func test_emailSignUp_deliversCredentialsOnValidInput() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let credentials = simulateValidEmailSignUp(on: sut)

        XCTAssertEqual(service.messages, [.register(credentials: credentials)])
    }

    func test_emailSignUp_doesNotDeliverCredentialsOnEmptyInput() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        sut.rootView.signUpButton.simulateTap()

        XCTAssertTrue(service.messages.isEmpty)
    }

    // MARK: - Apple Sign Up Tests
    func test_appleSignUp_deliversCredentialsOnValidProvider() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let credentials = simulateValidAppleSignUp(on: sut)

        XCTAssertEqual(service.messages, [.register(credentials: credentials)])
    }

    func test_appleSignUp_doesNotDeliverCredentialsOnInvalidProvider() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let provider = AppleCredentialsProviderSpy()
        sut.appleCredentialsProvider = provider
        provider.result = .failure(anyNSError())

        sut.rootView.signUpWithAppleButton.simulateTap()

        XCTAssertTrue(service.messages.isEmpty)
    }

    // MARK: - Navigation Tests
    func test_signIn_triggersNavigation() {
        var navigateToSignInCount = 0
        let (sut, _) = makeSUT(onSignIn: { navigateToSignInCount += 1 })
        sut.simulateAppearance()

        sut.rootView.signInButton.simulateTap()

        XCTAssertEqual(navigateToSignInCount, 1)
    }

    // MARK: - Success Navigation Tests
    func test_successfulSignUp_triggersNavigation() {
        var navigateToMainCount = 0
        let (sut, service) = makeSUT(onSuccess: { navigateToMainCount += 1 })
        sut.simulateAppearance()

        service.registerResult = .success(makeAuthenticatedUser())
        simulateValidEmailSignUp(on: sut)

        XCTAssertEqual(navigateToMainCount, 1)
    }

    // MARK: - Helpers
    private func makeSUT(
        onSignIn: @escaping () -> Void = {},
        onSuccess: @escaping () -> Void = {},
        file: StaticString = #file,
        line: UInt = #line
    ) -> (SignUpViewController, AuthenticationServiceSpy) {
        let service = AuthenticationServiceSpy()
        let sut = SignUpUIComposer.composed(
            email: service.register,
            apple: service.register,
            onSignIn: onSignIn,
            onSuccess: onSuccess
        )

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, service)
    }

    private func simulateValidEmailSignUp(
        on sut: SignUpViewController,
        fullName: String = "Any Name",
        email: String = "any@mail.com",
        password: String = "password"
    ) -> EmailSignUpCredentials {
        let credentials = EmailSignUpCredentials(name: fullName, email: email, password: password)
        sut.rootView.fullNameTextField.text = fullName
        sut.rootView.mailTextField.text = email
        sut.rootView.passTextField.text = password
        sut.rootView.signUpButton.simulateTap()
        return credentials
    }

    private func simulateValidAppleSignUp(on sut: SignUpViewController) -> AppleCredentials {
        let provider = AppleCredentialsProviderSpy()
        sut.appleCredentialsProvider = provider
        let credentials = makeAppleCredentials()
        provider.result = .success(credentials)
        sut.rootView.signUpWithAppleButton.simulateTap()
        return credentials
    }
}
