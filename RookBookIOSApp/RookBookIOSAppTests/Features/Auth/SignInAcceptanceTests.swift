// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
@testable import RookBookIOSApp
import RookBookCore
import XCTest

final class SignInAcceptanceTests: XCTestCase {
    // MARK: - Launch Tests
    func test_onLaunch_displaysSignInScreen_whenStateIsLogin() {
        let (sut, nav) = launchApp(with: .login)

        XCTAssertNotNil(sut)
        XCTAssertTrue(nav?.topViewController is SignInViewController)
    }

    // MARK: - Navigation Tests
    func test_successfulSignIn_navigatesToHome() {
        let store = MockAppStateStore(initialState: .login)
        let (sut, _, scene, service) = launchApp(store: store)

        simulateSuccessfulSignIn(on: sut, service: service)

        XCTAssertEqual(scene.compositionRoot.appStateStore.state(), .home)
    }

    // MARK: - Helpers
    private func launchApp(
        with state: AppState = .login
    ) -> (SignInViewController, UINavigationController?) {
        let (sut, nav, _, _) = launchApp(store: MockAppStateStore(initialState: state))
        return (sut, nav)
    }

    private func launchApp(
        store: AppStateStore
    ) -> (SignInViewController, UINavigationController?, SceneDelegate, AuthenticationServiceSpy) {
        let scene = SceneDelegate()
        let service = AuthenticationServiceSpy()

        configureScene(scene, with: store, service: service)

        let nav = scene.window?.rootViewController as? UINavigationController
        let sut = nav?.topViewController as! SignInViewController
        sut.simulateAppearance()

        return (sut, nav, scene, service)
    }

    private func configureScene(
        _ scene: SceneDelegate,
        with store: AppStateStore,
        service: AuthenticationServiceSpy
    ) {
        scene.compositionRoot.appStateStore = store
        scene.compositionRoot.mailAuthenticationService = service
        scene.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        scene.configureWindow()
    }

    private func simulateSuccessfulSignIn(
        on sut: SignInViewController,
        service: AuthenticationServiceSpy,
        email: String = "any@mail.com",
        password: String = "anyPassword"
    ) {
        service.loginResult = .success(makeAuthenticatedUser())
        sut.rootView.mailTextField.text = email
        sut.rootView.passTextField.text = password
        sut.rootView.signInButton.simulateTap()
    }
}
