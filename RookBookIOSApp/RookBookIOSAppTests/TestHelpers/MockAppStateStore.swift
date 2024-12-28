// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore

final class MockAppStateStore: AppStateStore {
    private var stateValue: AppState

    init(initialState: AppState) {
        stateValue = initialState
    }

    func state() -> AppState {
        stateValue
    }

    func update(_ newState: AppState) {
        stateValue = newState
    }
}
