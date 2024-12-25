// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

final class MockTokenStore: TokenStorable {
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

    func get() throws -> RookBookCore.Token? {
        switch stubbedResult {
        case .success:
            return storedToken
        case let .failure(error):
            throw error
        default:
            return nil
        }
    }

    func clear() throws {
        if case let .failure(error) = stubbedResult {
            throw error
        }
        storedToken = nil
    }
}
