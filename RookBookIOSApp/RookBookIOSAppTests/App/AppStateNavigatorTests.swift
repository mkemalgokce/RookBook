// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
@testable import RookBookIOSApp
import XCTest

final class AppStateNavigatorTests: XCTestCase {
    func test_navigate_whenStateIsOnboarding_showsOnboardingViewController() {
        let (sut, mockNavController, mockStore) = makeSUT(initialState: .onboarding)
        sut.navigate()

        XCTAssertEqual(mockNavController.viewControllers.count, 1)
        XCTAssertTrue(mockNavController.viewControllers.first is OnboardingViewController)
    }

    func test_navigate_whenStateIsLogin_showsLoginViewController() {
        let (sut, mockNavController, mockStore) = makeSUT(initialState: .login)

        sut.navigate()

        XCTAssertEqual(mockNavController.viewControllers.count, 1)
        XCTAssertTrue(mockNavController.viewControllers.first is UIViewController) // TODO: Replace
        XCTAssertEqual(mockNavController.viewControllers.first?.view.backgroundColor, .systemRed)
    }

    func test_navigate_whenStateIsHome_showsHomeViewController() {
        let (sut, mockNavController, mockStore) = makeSUT(initialState: .home)

        sut.navigate()

        XCTAssertEqual(mockNavController.viewControllers.count, 1)
        XCTAssertTrue(mockNavController.viewControllers.first is UIViewController) // TODO: Replace
        XCTAssertEqual(mockNavController.viewControllers.first?.view.backgroundColor, .systemGreen)
    }

    // MARK: - Helpers
    private func makeSUT(
        initialState: AppState,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (AppStateNavigator, MockNavigationController, MockAppStateStore) {
        let navigationController = MockNavigationController()
        let appStateStore = MockAppStateStore(initialState: initialState)
        let sut = AppStateNavigator(navigationController: navigationController, appStateStore: appStateStore)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(navigationController, file: file, line: line)
        trackForMemoryLeaks(appStateStore, file: file, line: line)

        return (sut, navigationController, appStateStore)
    }

    private final class MockNavigationController: UINavigationController {
        var capturedViewControllers: [UIViewController] = []

        override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
            capturedViewControllers = viewControllers
            super.setViewControllers(viewControllers, animated: animated)
        }
    }
}
