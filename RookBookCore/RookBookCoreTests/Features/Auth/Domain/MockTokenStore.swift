// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

final class MockTokenStore: TokenStorable {
    // MARK: - Nested Types
    private struct EmptyTokenError: Error {}

    // MARK: - Properties
    var storedToken: Token?
    var stubbedResult: Result<Token?, Error>?

    // MARK: - Internal Methods
    func store(token: RookBookCore.Token) throws {
        if case let .failure(error) = stubbedResult {
            throw error
        }
        storedToken = token
    }

    func get() throws -> RookBookCore.Token {
        if case let .failure(error) = stubbedResult {
            throw error
        }
        guard let token = storedToken else {
            throw EmptyTokenError()
        }
        return token
    }

    func clear() throws {
        if case let .failure(error) = stubbedResult {
            throw error
        }
        storedToken = nil
    }
}
