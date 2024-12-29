// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct TokenStorage {
    // MARK: - Properties
    public let accessTokenStore: TokenStorable
    public let refreshTokenStore: TokenStorable

    // MARK: - Initializers
    public init(accessTokenStore: TokenStorable, refreshTokenStore: TokenStorable) {
        self.accessTokenStore = accessTokenStore
        self.refreshTokenStore = refreshTokenStore
    }

    // MARK: - Internal Methods
    func storeTokens(accessToken: Token, refreshToken: Token) throws {
        try accessTokenStore.store(token: accessToken)
        try refreshTokenStore.store(token: refreshToken)
    }

    func clearStores() throws {
        try accessTokenStore.clear()
        try refreshTokenStore.clear()
    }
}
