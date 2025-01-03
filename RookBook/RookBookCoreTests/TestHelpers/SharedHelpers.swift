// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Foundation

func anyURL(value: String = "any") -> URL {
    URL(string: "https://\(value)-url.com")!
}

func anyURLRequest(url: URL? = nil) -> URLRequest {
    URLRequest(url: url ?? anyURL())
}

func anyNSError() -> NSError {
    NSError(domain: "Error", code: -1)
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}

func anyHTTPURLResponse(url: URL? = nil, statusCode: Int = 200, headers: [String: String] = [:]) -> HTTPURLResponse {
    HTTPURLResponse(url: url ?? anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: headers)!
}

func makeJSON(dict: [String: Any]) -> Data {
    try! JSONSerialization.data(withJSONObject: dict)
}

func encode<T: Encodable>(_ value: T) -> Data {
    try! JSONEncoder().encode(value)
}

func makeValidAuthenticatedResponse(refreshToken: String = "refreshtoken") -> HTTPURLResponse {
    anyHTTPURLResponse(
        statusCode: 200,
        headers: [
            "Set-Cookie": "refreshToken=\(refreshToken); path=/; HttpOnly"
        ]
    )
}

func makeAuthenticationResponse(accessToken: String = "accesstoken",
                                user: AuthenticatedUserDTO? = nil) -> AuthenticationResponseDTO {
    AuthenticationResponseDTO(user: user ?? makeAuthenticatedUserDTO(), accessToken: accessToken)
}

func makeAuthenticatedUserDTO() -> AuthenticatedUserDTO {
    AuthenticatedUserDTO(id: UUID(), email: "any@mail.com", name: "any name")
}

func makeSignInCredentials() -> EmailSignInCredentials {
    EmailSignInCredentials(
        email: "test@example.com",
        password: "Password123!@#"
    )
}

func makeAuthenticatedUser() -> AuthenticatedUser {
    AuthenticatedUser(
        id: "B8E5183C-830D-42B9-887A-D08E9B29E63B",
        email: "test@example.com",
        name: "John Doe"
    )
}
