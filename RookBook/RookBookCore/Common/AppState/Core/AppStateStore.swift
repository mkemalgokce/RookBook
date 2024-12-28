// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public protocol AppStateStore {
    func state() -> AppState
    func update(_ newState: AppState)
}
