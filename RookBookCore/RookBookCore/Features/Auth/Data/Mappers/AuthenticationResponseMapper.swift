// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

final class AuthenticationResponseMapper: ResponseMapping {
    // MARK: - Nested Types
    enum Error: Swift.Error {
        case invalidData
    }

    private enum Constants {
        static let cookieSection = "Set-Cookie"
        static let authorizationSection = "Authorization"
        static let refreshTokenKey = "refreshToken="
        static let bearerKey = "Bearer "
    }

    // MARK: - ResponseMapping Methods
    func map(data: Data, from response: HTTPURLResponse) throws -> AuthenticationResponse {
        guard response.hasValidStatusCode(in: 200..<201) else {
            throw Error.invalidData
        }
        let authorizationSection = response.allHeaderFields[Constants.authorizationSection]
        let cookieSection = response.allHeaderFields[Constants.cookieSection]

        do {
            let user = try decodeUser(data: data, from: response)
            let refreshToken = try extractToken(from: cookieSection, tokenKey: Constants.refreshTokenKey)
            let accessToken = try extractToken(from: authorizationSection, tokenKey: Constants.bearerKey)
            return AuthenticationResponse(accessToken: accessToken, refreshToken: refreshToken, user: user)
        } catch {
            throw error
        }
    }

    // MARK: - Private Methods
    private func decodeUser(data: Data, from response: HTTPURLResponse) throws -> AuthenticatedUserDTO {
        let mapper = DecodableResourceResponseMapper<AuthenticatedUserDTO>()
        do {
            return try mapper.map(data: data, from: response)
        } catch {
            throw Error.invalidData
        }
    }

    private func extractToken(from headerSection: Any?, tokenKey: String) throws -> Token {
        guard let headerString = headerSection as? String
        else { throw Error.invalidData }
        let components = headerString.components(separatedBy: tokenKey)
        return try parseToken(from: components)
    }

    private func parseToken(from components: [String]) throws -> Token {
        if components.count > 1 {
            let tokenValue = components[1].components(separatedBy: ";").first
            if let tokenValue, !tokenValue.isEmpty {
                return Token(tokenValue)
            }
        }
        throw Error.invalidData
    }
}
