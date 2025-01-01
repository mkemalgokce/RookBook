// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class AuthenticationResponseMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        try [199, 201, 300, 400, 500].enumerated().forEach { _, code in
            XCTAssertThrowsError(
                try makeSUT().map(data: anyData(), from: anyHTTPURLResponse(statusCode: code))
            ) { error in
                XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
            }
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSONAndMissingAuthorizationHeader() {
        XCTAssertThrowsError(
            try makeSUT().map(data: anyData(), from: anyHTTPURLResponse(statusCode: 200, headers: [:]))
        ) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_throwsErrorOn200HTTPResponseValidJSONAndMissingAuthorizationHeader() {
        let validResponse = anyHTTPURLResponse(statusCode: 200, headers: ["Set-Cookie": ""])
        let validJSON = makeJSON(dict: makeUserDict())

        XCTAssertThrowsError(
            try makeSUT().map(data: validJSON, from: validResponse)
        ) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_deliversTokenOn200HTTPResponseWithValidJSONAndAuthorizationHeader() throws {
        let accessToken = "any access token"
        let refreshToken = "any refresh token"

        let userDict = makeUserDict()
        let validResponse = makeValidResponse(accessToken: accessToken, refreshToken: refreshToken)
        let validDict = makeValidDict(accessToken: accessToken, userDict: userDict)
        let validJSON = makeJSON(dict: validDict)

        let result = try makeSUT().map(data: validJSON, from: validResponse)

        XCTAssertEqual(result.accessToken.stringValue, accessToken)
        XCTAssertEqual(result.refreshToken.stringValue, refreshToken)
        XCTAssertEqual(result.user.id.uuidString, userDict["id"] as? String)
        XCTAssertEqual(result.user.name, userDict["fullName"] as? String)
        XCTAssertEqual(result.user.email, userDict["email"] as? String)
    }

    func test_map_withMissingAuthorizationHeader_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: ["Set-Cookie": "refreshToken=refresh_token_456; path=/; HttpOnly"]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withMissingCookieHeader_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [:]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withInvalidAccessTokenFormat_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken=refresh_token_456; path=/; HttpOnly"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withInvalidRefreshTokenFormat_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "InvalidTokenFormat"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withEmptyAccessToken_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken=refresh_token_456; path=/; HttpOnly"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withEmptyRefreshToken_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken=; path=/; HttpOnly"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withEmptyCookieHeader_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: ["Set-Cookie": ""]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withMalformedRefreshTokenCookie_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "malformed_cookie_without_equals_sign"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withMultipleRefreshTokenCookies_usesFirstToken() throws {
        let firstToken = "first_token"
        let secondToken = "second_token"
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken=\(firstToken); path=/; HttpOnly, refreshToken=\(secondToken); path=/; HttpOnly"
            ]
        )

        let validDict = makeValidDict()
        let validJSON = makeJSON(dict: validDict)

        let result = try makeSUT().map(data: validJSON, from: response)
        XCTAssertEqual(result.refreshToken.stringValue, firstToken)
    }

    func test_map_withRefreshTokenCookieWithoutValue_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Authorization": "Bearer access_token_123",
                "Set-Cookie": "refreshToken"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withRefreshTokenCookieWithExtraSpaces_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Authorization": "Bearer access_token_123",
                "Set-Cookie": "refreshToken  =  token_with_spaces  ; path=/; HttpOnly"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withEmptyComponents_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Authorization": "Bearer access_token_123",
                "Set-Cookie": ""
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withSingleComponent_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Authorization": "Bearer access_token_123",
                "Set-Cookie": "single_component"
            ]
        )

        XCTAssertThrowsError(try makeSUT().map(data: Data(), from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    func test_map_withEmptyTokenValueAfterSemicolon_throwsInvalidDataError() {
        let response = anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken"
            ]
        )

        let validData = makeJSON(dict: makeValidDict())
        XCTAssertThrowsError(try makeSUT().map(data: validData, from: response)) { error in
            XCTAssertEqual(error as? AuthenticationResponseMapper.Error, .invalidData)
        }
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> AuthenticationResponseMapper {
        let sut = AuthenticationResponseMapper()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func makeValidResponse(accessToken: String = "access",
                                   refreshToken: String = "refresh") -> HTTPURLResponse {
        anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken=\(refreshToken); path=/; HttpOnly"
            ]
        )
    }

    private func makeValidDict(accessToken: String = "access", userDict: [String: Any]? = nil) -> [String: Any] {
        [
            "accessToken": accessToken,
            "user": userDict ?? makeUserDict()
        ]
    }

    private func makeUserDict() -> [String: Any] {
        [
            "id": UUID().uuidString,
            "fullName": "any name",
            "email": "any email"
        ]
    }
}
