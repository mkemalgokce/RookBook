@testable import RookBookCore
// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.
import XCTest

final class AuthEndpointTests: XCTestCase {
    func test_appendingPath_returnsCorrectValue() {
        let sut = AuthEndpoint.login

        XCTAssertEqual(sut.appendingPath, "auth")
    }

    func test_url_returnsCorrectURLForLoginEndpoint() {
        let baseURL = anyURL()
        let sut = AuthEndpoint.login

        let url = sut.url(baseURL: baseURL)

        XCTAssertEqual(
            url.absoluteString,
            baseURL.appendingPathComponent("auth/login").absoluteString
        )
    }

    func test_url_returnsCorrectURLForRegisterEndpoint() {
        let baseURL = anyURL()
        let sut = AuthEndpoint.register

        let url = sut.url(baseURL: baseURL)

        XCTAssertEqual(
            url.absoluteString,
            baseURL.appendingPathComponent("auth/register").absoluteString
        )
    }

    func test_url_returnsCorrectURLForLogoutEndpoint() {
        let baseURL = anyURL()
        let sut = AuthEndpoint.logout

        let url = sut.url(baseURL: baseURL)

        XCTAssertEqual(
            url.absoluteString,
            baseURL.appendingPathComponent("auth/logout").absoluteString
        )
    }

    func test_url_preservesBaseURLScheme() {
        let baseURL = anyURL()
        let sut = AuthEndpoint.login

        let url = sut.url(baseURL: baseURL)

        XCTAssertEqual(url.scheme, "https")
    }

    func test_url_preservesBaseURLPath() {
        let baseURL = anyURL().appendingPathComponent("api/v1")
        let sut = AuthEndpoint.login

        let url = sut.url(baseURL: baseURL)

        XCTAssertEqual(
            url.absoluteString,
            baseURL.appendingPathComponent("auth/login").absoluteString
        )
    }
}
