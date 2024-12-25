// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class TokenStorageTests: XCTestCase {
    func test_storeTokens() throws {
        let (sut, accessTokenStore, refreshTokenStore) = makeSUT()
        let accessToken = Token("accessToken")
        let refreshToken = Token("refreshToken")

        try sut.storeTokens(accessToken: accessToken, refreshToken: refreshToken)

        XCTAssertEqual(accessTokenStore.storedToken, accessToken)
        XCTAssertEqual(refreshTokenStore.storedToken, refreshToken)
    }

    func test_clearTokens_clearsBothStores() throws {
        let (sut, accessTokenStore, refreshTokenStore) = makeSUT()
        let accessToken = Token("accessToken")
        let refreshToken = Token("refreshToken")

        try sut.storeTokens(accessToken: accessToken, refreshToken: refreshToken)
        try sut.clearStores()

        XCTAssertNil(accessTokenStore.storedToken)
        XCTAssertNil(refreshTokenStore.storedToken)
    }

    func test_clearTokens_throwsErrorOnClearingAccessTokenStore() throws {
        let (sut, accessTokenStore, _) = makeSUT()
        accessTokenStore.stubbedResult = .failure(anyNSError())

        XCTAssertThrowsError(try sut.clearStores())
    }

    func test_clearTokens_throwsErrorOnClearingRefreshTokenStore() throws {
        let (sut, _, refreshTokenStore) = makeSUT()
        refreshTokenStore.stubbedResult = .failure(anyNSError())

        XCTAssertThrowsError(try sut.clearStores())
    }

    func test_getTokens_throwsErrorOnGettingAccessToken() throws {
        let (sut, accessTokenStore, _) = makeSUT()
        let accessToken = Token("accessToken")
        let refreshToken = Token("refreshToken")

        accessTokenStore.stubbedResult = .failure(anyNSError())

        XCTAssertThrowsError(try sut.storeTokens(accessToken: accessToken, refreshToken: refreshToken))
    }

    func test_getTokens_throwsErrorOnGettingRefreshToken() throws {
        let (sut, _, refreshTokenStore) = makeSUT()
        let accessToken = Token("accessToken")
        let refreshToken = Token("refreshToken")

        refreshTokenStore.stubbedResult = .failure(anyNSError())

        XCTAssertThrowsError(try sut.storeTokens(accessToken: accessToken, refreshToken: refreshToken))
    }

    // MARK: - Helpers
    private func makeSUT() -> (sut: TokenStorage, accessTokenStore: MockTokenStore, refreshTokenStore: MockTokenStore) {
        let accessTokenStore = MockTokenStore()
        let refreshTokenStore = MockTokenStore()
        let sut = TokenStorage(accessTokenStore: accessTokenStore, refreshTokenStore: refreshTokenStore)
        return (sut, accessTokenStore, refreshTokenStore)
    }
}
