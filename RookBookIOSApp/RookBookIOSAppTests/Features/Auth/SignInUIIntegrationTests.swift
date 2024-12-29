// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
@testable import RookBookIOSApp
import XCTest

final class SignInUIIntegrationTests: XCTestCase {
    // MARK: - UI Configuration Tests
    func test_viewDidLoad_configuresViewWithCorrectTexts() {
        let (sut, _) = makeSUT()
        sut.simulateAppearance()

        XCTAssertEqual(sut.title, SignIn.title)
        XCTAssertEqual(sut.rootView.mailTextField.placeholder, SignIn.emailPlaceholder)
        XCTAssertEqual(sut.rootView.passTextField.placeholder, SignIn.passwordPlaceholder)
        XCTAssertEqual(sut.rootView.signInButton.title(for: .normal), SignIn.signInButtonTitle)
        XCTAssertEqual(sut.rootView.signInWithAppleButton.title(for: .normal), SignIn.signInWithAppleButtonTitle)
        XCTAssertEqual(sut.rootView.signUpButton.attributedTitle(for: .normal)?.string, SignIn.signUpButtonTitle)
    }

    // MARK: - Email Sign In Tests
    func test_emailSignIn_deliversCredentialsOnValidInput() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let credentials = simulateValidEmailSignIn(on: sut)

        XCTAssertEqual(service.messages, [.login(credentials: credentials)])
    }

    func test_emailSignIn_doesNotDeliverCredentialsOnEmptyInput() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        sut.rootView.signInButton.simulateTap()

        XCTAssertTrue(service.messages.isEmpty)
    }

    // MARK: - Apple Sign In Tests
    func test_appleSignIn_deliversCredentialsOnValidProvider() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let credentials = simulateValidAppleSignIn(on: sut)

        XCTAssertEqual(service.messages, [.login(credentials: credentials)])
    }

    func test_appleSignIn_doesNotDeliverCredentialsOnInvalidProvider() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let provider = AppleCredentialsProviderSpy()
        sut.appleCredentialsProvider = provider
        provider.result = .failure(anyNSError())

        sut.rootView.signInWithAppleButton.simulateTap()

        XCTAssertTrue(service.messages.isEmpty)
    }

    // MARK: - Navigation Tests
    func test_signUp_triggersNavigation() {
        var navigateToSignUpCount = 0
        let (sut, _) = makeSUT(onSignUp: { navigateToSignUpCount += 1 })
        sut.simulateAppearance()

        sut.rootView.signUpButton.simulateTap()

        XCTAssertEqual(navigateToSignUpCount, 1)
    }

    // MARK: - Success Navigation Tests
    func test_successfulSignIn_triggersNavigation() {
        var navigateToMainCount = 0
        let (sut, service) = makeSUT(onSuccess: { navigateToMainCount += 1 })
        sut.simulateAppearance()

        service.loginResult = .success(makeAuthenticatedUser())
        simulateValidEmailSignIn(on: sut)

        XCTAssertEqual(navigateToMainCount, 1)
    }

    // MARK: - Helpers
    private func makeSUT(
        onSignUp: @escaping () -> Void = {},
        onSuccess: @escaping () -> Void = {},
        file: StaticString = #file,
        line: UInt = #line
    ) -> (SignInViewController, AuthenticationServiceSpy) {
        let service = AuthenticationServiceSpy()
        let sut = SignInUIComposer.composed(
            emailSignInPublisher: service.login,
            appleSignInPublisher: service.login,
            onSignUp: onSignUp,
            onSuccess: onSuccess
        )

        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, service)
    }

    @discardableResult
    private func simulateValidEmailSignIn(
        on sut: SignInViewController,
        email: String = "any@mail.com",
        password: String = "password"
    ) -> EmailSignInCredentials {
        let credentials = EmailSignInCredentials(email: email, password: password)
        sut.rootView.mailTextField.text = email
        sut.rootView.passTextField.text = password
        sut.rootView.signInButton.simulateTap()
        return credentials
    }

    private func simulateValidAppleSignIn(on sut: SignInViewController) -> AppleCredentials {
        let provider = AppleCredentialsProviderSpy()
        sut.appleCredentialsProvider = provider
        let credentials = makeAppleCredentials()
        provider.result = .success(credentials)
        sut.rootView.signInWithAppleButton.simulateTap()
        return credentials
    }
}
