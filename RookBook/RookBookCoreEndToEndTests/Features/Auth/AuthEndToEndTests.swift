import Combine
import RookBookCore
import XCTest

final class AuthEndToEndTests: XCTestCase {
    // MARK: - Properties
    private let baseURL = URL(string: "https://verdant-pen-production.up.railway.app/api")!

    // MARK: - Login Tests
    func test_login_deliversAuthenticatedUserOnValidCredentials() {
        let (sut, _) = makeSUT()
        let credentials = makeSignInCredentials()
        let expectedUser = makeAuthenticatedUser()

        expectPublisher(sut.login(with: credentials),
                        toCompleteWith: .success(expectedUser))
    }

    func test_login_storesTokensOnSuccess() {
        let (sut, stores) = makeSUT()
        let credentials = makeSignInCredentials()
        let expectedUser = makeAuthenticatedUser()

        expectPublisher(sut.login(with: credentials),
                        toCompleteWith: .success(expectedUser))

        XCTAssertNotNil(stores.accessToken.storedToken,
                        "Expected access token to be stored")
        XCTAssertNotNil(stores.refreshToken.storedToken,
                        "Expected refresh token to be stored")
    }

    // MARK: - Logout Tests
    func test_logout_succeeds() {
        let (sut, _) = makeSUT()
        let credentials = makeSignInCredentials()
        let expectedUser = makeAuthenticatedUser()

        expectPublisher(sut.login(with: credentials),
                        toCompleteWith: .success(expectedUser))
        expectPublisher(sut.logout(),
                        toCompleteWith: .success(()))
    }

    func test_logout_clearsTokens() {
        let (sut, stores) = makeSUT()
        let credentials = makeSignInCredentials()
        let expectedUser = makeAuthenticatedUser()

        expectPublisher(sut.login(with: credentials),
                        toCompleteWith: .success(expectedUser))
        expectPublisher(sut.logout(),
                        toCompleteWith: .success(()))

        XCTAssertThrowsError(try stores.accessToken.get(),
                             "Expected access token to be cleared")
        XCTAssertThrowsError(try stores.refreshToken.get(),
                             "Expected refresh token to be cleared")
    }
}

// MARK: - Test Helpers
extension AuthEndToEndTests {
    fileprivate typealias SUTComponents = (
        sut: RemoteAuthenticationService,
        stores: (accessToken: MockTokenStore, refreshToken: MockTokenStore)
    )

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SUTComponents {
        let client = ephemeralClient()
        let accessTokenStore = MockTokenStore()
        let refreshTokenStore = MockTokenStore()
        let tokenStorage = TokenStorage(
            accessTokenStore: accessTokenStore,
            refreshTokenStore: refreshTokenStore
        )

        let logoutRequestBuilder = { [weak self] in
            self?.buildLogoutRequest(tokenStore: accessTokenStore)
                ?? URLRequest(url: anyURL())
        }

        let sut = RemoteAuthenticationService(
            client: client,
            buildSignInRequest: buildRequest(for: .login),
            buildSignUpRequest: buildRequest(for: .register),
            buildLogoutRequest: logoutRequestBuilder,
            storage: tokenStorage
        )

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(accessTokenStore, file: file, line: line)
        trackForMemoryLeaks(refreshTokenStore, file: file, line: line)

        return (sut, (accessTokenStore, refreshTokenStore))
    }

    private func makeSignInCredentials() -> EmailSignInCredentials {
        EmailSignInCredentials(
            email: "test@example.com",
            password: "Password123!@#"
        )
    }

    private func makeAuthenticatedUser() -> AuthenticatedUser {
        AuthenticatedUser(
            id: "B8E5183C-830D-42B9-887A-D08E9B29E63B",
            email: "test@example.com",
            name: "John Doe"
        )
    }
}

// MARK: - Network Helpers
extension AuthEndToEndTests {
    private func buildRequest(for endpoint: AuthEndpoint) -> (Credentials) -> URLRequest {
        { credentials in
            let headers = ["Content-Type": "application/json"]
            return DictionaryRequestBuilder.build(
                on: endpoint.url(baseURL: self.baseURL),
                from: credentials,
                with: .post,
                headers: headers
            )
        }
    }

    private func buildLogoutRequest(tokenStore: MockTokenStore) -> URLRequest {
        guard let token = tokenStore.storedToken?.value else {
            fatalError("Token must be available for logout request")
        }

        var request = AuthEndpoint.logout.url(baseURL: baseURL).request(for: .post)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func ephemeralClient(file: StaticString = #filePath,
                                 line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral)
        )
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
}
