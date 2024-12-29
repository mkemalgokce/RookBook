// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
@testable import RookBookIOSApp
import XCTest

final class SceneDelegateTests: XCTestCase {
    func test_configureWindow_setsWindowsAsKeyAndVisible() {
        let window = UIWindowSpy()
        let (sut, _) = makeSUT(window: window)

        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 0)
        sut.configureWindow()
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
    }

    func test_configureWindow_setsRootViewController() {
        let window = UIWindow()
        let (sut, _) = makeSUT(window: window)

        sut.configureWindow()

        XCTAssertTrue(window.rootViewController is UINavigationController)
    }

    func test_configureWindow_callsNavigateOnAppStateNavigator() {
        let (sut, navigator) = makeSUT()

        XCTAssertEqual(navigator.navigateCallCount, 0)
        sut.configureWindow()
        XCTAssertEqual(navigator.navigateCallCount, 1)
    }

    // MARK: - Helpers
    private func makeSUT(window: UIWindow? = nil, file: StaticString = #file,
                         line: UInt = #line) -> (SceneDelegate, MockAppStateNavigator) {
        let navigator = MockAppStateNavigator()
        let sut = SceneDelegate()
        sut.compositionRoot.appStateNavigator = navigator
        if let window {
            sut.window = window
        }
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(navigator, file: file, line: line)
        return (sut, navigator)
    }

    private class UIWindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0

        override func makeKeyAndVisible() {
            makeKeyAndVisibleCallCount += 1
        }
    }

    private final class MockAppStateNavigator: AppStateNavigating {
        var navigateCallCount = 0
        func navigate() {
            navigateCallCount += 1
        }
    }
}
