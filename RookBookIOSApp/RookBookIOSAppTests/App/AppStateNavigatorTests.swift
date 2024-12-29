// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
@testable import RookBookIOSApp
import XCTest
final class AppStateNavigatorTests: XCTestCase {
    func test_init_doesNotNavigate() {
        let (sut, deps) = makeSUT(initialState: .onboarding)

        XCTAssertEqual(deps.navigation.viewControllers.count, 0)
        XCTAssertEqual(deps.factory.messages, [])
    }

    func test_navigate_whenStateIsOnboarding_showsOnboardingViewController() {
        let (sut, deps) = makeSUT(initialState: .onboarding)
        let onboardingViewController = OnboardingViewController()
        deps.factory.onboardingViewController = onboardingViewController
        sut.navigate()

        XCTAssertEqual(deps.factory.messages, [.makeOnboardingViewController])
        XCTAssertEqual(deps.navigation.viewControllers, [onboardingViewController])
    }

    func test_navigate_whenStateIsLogin_showsLoginViewController() {
        let (sut, deps) = makeSUT(initialState: .login)
        let signInViewController = SignInViewController()

        deps.factory.loginViewController = signInViewController

        sut.navigate()

        XCTAssertEqual(deps.factory.messages, [.makeLoginViewController])
        XCTAssertEqual(deps.navigation.viewControllers, [signInViewController])
    }

    func test_navigate_whenStateIsHome_showsHomeViewController() {
        let (sut, deps) = makeSUT(initialState: .home)
        let homeViewController = UIViewController()

        deps.factory.homeViewController = homeViewController

        sut.navigate()

        XCTAssertEqual(deps.factory.messages, [.makeHomeViewController])
        XCTAssertEqual(deps.navigation.viewControllers, [homeViewController])
    }

    // MARK: - Helpers
    private func makeSUT(
        initialState: AppState,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (AppStateNavigator, (navigation: MockNavigationController, factory: ViewControllerFactorySpy)) {
        let navigationController = MockNavigationController()
        let appStateStore = MockAppStateStore(initialState: initialState)
        let factory = ViewControllerFactorySpy()
        let sut = AppStateNavigator(
            navigationController: navigationController,
            appStateStore: appStateStore,
            viewControllerFactory: factory
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(navigationController, file: file, line: line)
        trackForMemoryLeaks(appStateStore, file: file, line: line)
        trackForMemoryLeaks(factory, file: file, line: line)
        return (sut, (navigationController, factory))
    }

    private final class MockNavigationController: UINavigationController {
        var capturedViewControllers: [UIViewController] = []
        var isAnmimated: Bool = false

        override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
            capturedViewControllers = viewControllers
            isAnmimated = animated
            super.setViewControllers(viewControllers, animated: animated)
        }
    }

    private final class ViewControllerFactorySpy: AppStateNavigatorViewControllerFactory {
        enum Message: Hashable {
            case makeLoginViewController
            case makeHomeViewController
            case makeOnboardingViewController
        }

        private(set) var messages: [Message] = []

        var loginViewController: UIViewController = .init()
        var homeViewController: UIViewController = .init()
        var onboardingViewController: UIViewController = .init()
        func makeLoginViewController() -> UIViewController {
            messages.append(.makeLoginViewController)
            return loginViewController
        }

        func makeHomeViewController() -> UIViewController {
            messages.append(.makeHomeViewController)
            return homeViewController
        }

        func makeOnboardingViewController() -> UIViewController {
            messages.append(.makeOnboardingViewController)
            return onboardingViewController
        }
    }
}
