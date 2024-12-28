// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class UserDefaultsAppStateStoreTests: XCTestCase {
    // MARK: - Lifecycle
    override func tearDown() {
        super.tearDown()
        clearUserDefaults()
    }

    // MARK: - Tests
    func test_state_whenNoStateStored_returnsOnboarding() {
        let (sut, _) = makeSUT()
        let state = sut.state()
        XCTAssertEqual(state, .onboarding)
    }

    func test_state_whenStoredStateExists_returnsCorrectState() {
        let (sut, _) = makeSUT()
        sut.update(.home)

        let state = sut.state()

        XCTAssertEqual(state, .home)
    }

    func test_state_whenStoredStateIsInvalid_returnsOnboarding() {
        let (sut, userDefaults) = makeSUT()
        userDefaults.setValue(16, forKey: UserDefaultsAppStateStore.Constants.stateKey)

        let state = sut.state()

        XCTAssertEqual(state, .onboarding)
    }

    func test_update_setsNewStateInUserDefaults() {
        let (sut, userDefaults) = makeSUT()
        let newState: AppState = .login

        sut.update(newState)

        let storedState = userDefaults.value(forKey: UserDefaultsAppStateStore.Constants.stateKey) as? UInt8
        XCTAssertEqual(storedState, newState.rawValue)
    }

    // MARK: - Helpers
    private func makeSUT() -> (sut: UserDefaultsAppStateStore, userDefaults: UserDefaults) {
        let userDefaults = UserDefaults(suiteName: "test")!
        let sut = UserDefaultsAppStateStore(userDefaults: userDefaults)
        return (sut, userDefaults)
    }

    private func clearUserDefaults() {
        let userDefaults = UserDefaults(suiteName: "test")!
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
