// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct UserDefaultsAppStateStore: AppStateStore {
    // MARK: - Nested Types
    enum Constants {
        static let stateKey = "app_state"
    }

    // MARK: - Properties
    private let userDefaults: UserDefaults

    // MARK: - Initializers
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - State Retrieval
    public func state() throws -> AppState {
        guard let storedStateRawValue = userDefaults.value(forKey: Constants.stateKey) as? UInt8 else {
            return .onboarding
        }

        guard let appState = AppState(rawValue: storedStateRawValue) else {
            return .onboarding
        }

        return appState
    }

    // MARK: - State Update
    public func update(_ newState: AppState) throws {
        userDefaults.setValue(newState.rawValue, forKey: Constants.stateKey)
    }
}
