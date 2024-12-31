// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

final class AuthenticationResponseMapper: ResponseMapping {
    // MARK: - Nested Types
    enum Error: Swift.Error {
        case invalidData
    }

    private enum Constants {
        static let cookieSection = "Set-Cookie"
        static let refreshTokenKey = "refreshToken="
    }

    // MARK: - ResponseMapping Methods
    func map(data: Data, from response: HTTPURLResponse) throws -> AuthenticationResponse {
        guard response.hasValidStatusCode(in: 200..<201) else {
            throw Error.invalidData
        }
        let cookieSection = response.allHeaderFields[Constants.cookieSection]

        do {
            let response = try decodeResponse(data: data, from: response)
            let refreshToken = try extractRefreshToken(from: cookieSection, tokenKey: Constants.refreshTokenKey)
            return AuthenticationResponse(
                accessToken: Token(response.accessToken),
                refreshToken: refreshToken,
                user: response.user
            )
        } catch {
            throw error
        }
    }

    // MARK: - Private Methods
    private func decodeResponse(data: Data, from response: HTTPURLResponse) throws -> AuthenticationResponseDTO {
        let mapper = DecodableResourceResponseMapper<AuthenticationResponseDTO>()
        do {
            return try mapper.map(data: data, from: response)
        } catch {
            throw Error.invalidData
        }
    }

    private func extractRefreshToken(from headerSection: Any?, tokenKey: String) throws -> Token {
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
