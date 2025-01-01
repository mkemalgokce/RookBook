// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class EmailAuthenticationServiceTests: XCTestCase {
    // MARK: - Init Tests
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client, _, _) = makeSUT()

        XCTAssertTrue(client.requests.isEmpty)
    }

    func test_init_doesNotStoreAnyTokens() {
        let (_, _, accessTokenStore, refreshTokenStore) = makeSUT()

        XCTAssertNil(accessTokenStore.storedToken)
        XCTAssertNil(refreshTokenStore.storedToken)
    }

    // MARK: - SignIn Tests
    func test_signIn_callsClientWithSignInRequest() {
        let (sut, client, _, _) = makeSUT()

        _ = sut.login(with: MockCredentials())

        XCTAssertEqual(client.requests, [makeSignInRequest()])
    }

    func test_signIn_deliversErrorOnClientError() {
        let (sut, client, _, _) = makeSUT()
        let clientError = NSError(domain: "any", code: 0)

        expectPublisher(sut.login(with: MockCredentials()), toCompleteWith: .failure(clientError), when: {
            client.complete(withError: clientError)
        })
    }

    func test_signIn_deliversUserOnSuccess() {
        let (sut, client, _, _) = makeSUT()
        let credentials = MockCredentials()
        let userDTO = makeAuthenticatedUserDTO()
        let responseDTO = makeAuthenticationResponse(user: userDTO)
        let user = AuthenticatedUserMapper.map(userDTO)
        let validResponse = makeValidHTTPResponse()

        expectPublisher(sut.login(with: credentials), toCompleteWith: .success(user), when: {
            client.complete(with: encode(responseDTO), and: validResponse)
        })
    }

    func test_signIn_storesTokensOnSuccess() {
        let (sut, client, accessTokenStore, refreshTokenStore) = makeSUT()
        let credentials = MockCredentials()
        let userDTO = makeAuthenticatedUserDTO()
        let user = AuthenticatedUserMapper.map(userDTO)
        let accessToken = "anyaccesstoken"
        let refreshToken = "anyrefreshtoken"
        let responseDTO = makeAuthenticationResponse(accessToken: accessToken, user: userDTO)

        let validResponse = makeValidHTTPResponse(refreshToken: refreshToken)

        expectPublisher(sut.login(with: credentials), toCompleteWith: .success(user), when: {
            client.complete(with: encode(responseDTO), and: validResponse)
        })

        XCTAssertEqual(accessTokenStore.storedToken?.stringValue, accessToken)
        XCTAssertEqual(refreshTokenStore.storedToken?.stringValue, refreshToken)
    }

    // MARK: - SignUp Tests
    func test_signUp_callsClientWithSignUpRequest() {
        let (sut, client, _, _) = makeSUT()

        _ = sut.register(with: MockCredentials())

        XCTAssertEqual(client.requests, [makeSignUpRequest()])
    }

    func test_signUp_deliversErrorOnClientError() {
        let (sut, client, _, _) = makeSUT()
        let clientError = anyNSError()

        expectPublisher(sut.register(with: MockCredentials()), toCompleteWith: .failure(clientError), when: {
            client.complete(withError: clientError)
        })
    }

    func test_signUp_deliversUserOnSuccess() {
        let (sut, client, _, _) = makeSUT()
        let credentials = MockCredentials()
        let userDTO = makeAuthenticatedUserDTO()
        let user = AuthenticatedUserMapper.map(userDTO)
        let responseDTO = makeAuthenticationResponse(user: userDTO)
        let validResponse = makeValidHTTPResponse()

        expectPublisher(sut.register(with: credentials), toCompleteWith: .success(user), when: {
            client.complete(with: encode(responseDTO), and: validResponse)
        })
    }

    func test_signUp_storesTokensOnSuccess() {
        let (sut, client, accessTokenStore, refreshTokenStore) = makeSUT()
        let credentials = MockCredentials()
        let userDTO = makeAuthenticatedUserDTO()
        let user = AuthenticatedUserMapper.map(userDTO)
        let accessToken = "anyaccesstoken"
        let refreshToken = "anyrefreshtoken"
        let responseDTO = makeAuthenticationResponse(accessToken: accessToken, user: userDTO)
        let validResponse = makeValidHTTPResponse(refreshToken: refreshToken)

        expectPublisher(sut.register(with: credentials), toCompleteWith: .success(user), when: {
            client.complete(with: encode(responseDTO), and: validResponse)
        })

        XCTAssertEqual(accessTokenStore.storedToken?.stringValue, accessToken)
        XCTAssertEqual(refreshTokenStore.storedToken?.stringValue, refreshToken)
    }

    // MARK: - Logout Tests
    func test_logout_callsClientWithLogoutRequest() {
        let (sut, client, _, _) = makeSUT()
        _ = sut.logout()
        XCTAssertEqual(client.requests, [makeLogoutRequest()])
    }

    func test_logout_deliversErrorOnClientError() {
        let (sut, client, _, _) = makeSUT()
        let clientError = anyNSError()
        expectPublisher(sut.logout(), toCompleteWith: .failure(clientError), when: {
            client.complete(withError: clientError)
        })
    }

    func test_logout_removesTokensOnSuccess() {
        let (sut, client, accessTokenStore, refreshTokenStore) = makeSUT()
        let validResponse = anyHTTPURLResponse(statusCode: 200)

        accessTokenStore.storedToken = Token("accessToken")
        refreshTokenStore.storedToken = Token("refreshToken")

        expectPublisher(sut.logout(), toCompleteWith: .success(()), when: {
            client.complete(with: Data(), and: validResponse)
        })

        XCTAssertNil(accessTokenStore.storedToken)
        XCTAssertNil(refreshTokenStore.storedToken)
    }

    // MARK: - Helpers
    private func makeSUT(
        signInRequest: URLRequest? = nil,
        signUpRequest: URLRequest? = nil,
        logoutRequest: URLRequest? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: RemoteAuthenticationService,
        client: HTTPClientSpy,
        accessTokenStore: MockTokenStore,
        refreshTokenStore: MockTokenStore
    ) {
        let client = HTTPClientSpy()
        let signInRequest = signInRequest ?? makeSignInRequest()
        let signUpRequest = signUpRequest ?? makeSignUpRequest()
        let logoutRequest = logoutRequest ?? makeLogoutRequest()

        let accessTokenStore = MockTokenStore()
        let refreshTokenStore = MockTokenStore()
        let sut = RemoteAuthenticationService(
            client: client,
            buildSignInRequest: { _ in signInRequest },
            buildSignUpRequest: { _ in signUpRequest },
            buildLogoutRequest: { logoutRequest },
            storage: TokenStorage(accessTokenStore: accessTokenStore, refreshTokenStore: refreshTokenStore)
        )

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(accessTokenStore, file: file, line: line)
        trackForMemoryLeaks(refreshTokenStore, file: file, line: line)
        return (sut, client, accessTokenStore, refreshTokenStore)
    }

    private func makeSignInRequest() -> URLRequest {
        anyURLRequest(url: anyURL(value: "sign-in"))
    }

    private func makeSignUpRequest() -> URLRequest {
        anyURLRequest(url: anyURL(value: "sign-up"))
    }

    private func makeLogoutRequest() -> URLRequest {
        anyURLRequest(url: anyURL(value: "logout"))
    }

    private func makeValidHTTPResponse(refreshToken: String = "refreshtoken") -> HTTPURLResponse {
        anyHTTPURLResponse(
            statusCode: 200,
            headers: [
                "Set-Cookie": "refreshToken=\(refreshToken); path=/; HttpOnly"
            ]
        )
    }

    private func makeAuthenticationResponse(accessToken: String = "accesstoken",
                                            user: AuthenticatedUserDTO? = nil) -> AuthenticationResponseDTO {
        AuthenticationResponseDTO(user: user ?? makeAuthenticatedUserDTO(), accessToken: accessToken)
    }

    private func makeAuthenticatedUserDTO() -> AuthenticatedUserDTO {
        AuthenticatedUserDTO(id: UUID(), email: "any@mail.com", name: "any name")
    }

    private struct MockCredentials: SignInCredentials, SignUpCredentials {
        var password: String = "password"
        func toStringDictionary() -> [String: Any?] {
            ["password": password]
        }
    }
}
