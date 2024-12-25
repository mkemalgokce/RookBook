// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

struct TokenStorage {
    // MARK: - Properties
    let accessTokenStore: TokenStorable
    let refreshTokenStore: TokenStorable

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
