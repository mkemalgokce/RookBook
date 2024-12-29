// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOSApp
import RookBookCore
import RookBookIOS
import XCTest

final class OnboardingAcceptanceTests: XCTestCase {
    func test_onOnboardingCompletion_displaysSignIn() {
        let appStateStore = MockAppStateStore(initialState: .onboarding)
        let (sut, nav, scene) = launch(appStateStore: appStateStore)

        simulateOnboardingCompletion(vc: sut)

        XCTAssertTrue(nav?.topViewController is SignInViewController)
    }

    // MARK: - Helpers
    private func launch(appStateStore: AppStateStore)
        -> (OnboardingViewController, UINavigationController?, SceneDelegate) {
        let sut = SceneDelegate()
        sut.compositionRoot.appStateStore = appStateStore
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 1))
        sut.configureWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        let vc = nav?.topViewController as! OnboardingViewController

        vc.simulateAppearance()
        return (vc, nav, sut)
    }

    private func simulateOnboardingCompletion(vc: OnboardingViewController) {
        for _ in 0..<3 {
            vc.simulateNextButtonTap()
        }
    }
}
