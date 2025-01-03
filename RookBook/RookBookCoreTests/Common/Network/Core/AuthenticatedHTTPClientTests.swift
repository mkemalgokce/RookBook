// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

final class AuthenticatedHTTPClientTests: XCTestCase {
    func test_perform_signsRequestBeforeSending() {
        let (sut, client, _, _) = makeSUT()
        let request = anyURLRequest()

        expectRequest(sut.perform(request), toCompleteWith: .success((anyData(), anyHTTPURLResponse()))) {
            client.complete(with: anyData(), and: anyHTTPURLResponse())
        }

        XCTAssertEqual(
            client.requests.first?.value(forHTTPHeaderField: "Authorization"),
            "Bearer token"
        )
    }

    func test_perform_deliversSuccessfulResponseOnValidRequest() {
        let (sut, client, _, _) = makeSUT()
        let request = anyURLRequest()
        let expectedData = anyData()
        let response = anyHTTPURLResponse()

        expectRequest(sut.perform(request), toCompleteWith: .success((expectedData, response))) {
            client.complete(with: expectedData, and: response)
        }
    }

    func test_perform_refreshesTokenAndRetriesOnUnauthorized() {
        let (sut, client, accessTokenStore, refreshTokenStore) = makeSUT()
        let request = anyURLRequest()
        let accessToken = "new_access_token"
        let refreshToken = "new_refresh_token"
        let refreshData = encode(makeAuthenticationResponse(accessToken: accessToken))

        expectRequest(sut.perform(request), toCompleteWith: .success((anyData(), anyHTTPURLResponse()))) {
            client.complete(withStatusCode: 401)
            client.complete(with: refreshData, and: makeValidAuthenticatedResponse(refreshToken: refreshToken), at: 1)
            client.complete(with: anyData(), and: anyHTTPURLResponse(), at: 2)
        }

        XCTAssertEqual(client.requests.count, 3)
        XCTAssertEqual(accessTokenStore.storedToken?.value, accessToken)
        XCTAssertEqual(refreshTokenStore.storedToken?.value, refreshToken)
    }

    func test_perform_callsUnauthorizedHandlerOnRefreshFailure() {
        let (sut, client, _, _) = makeSUT()
        let request = anyURLRequest()
        let exp = expectation(description: "Wait for unauthorized handler")
        sut.unauthorizedHandler = { exp.fulfill() }

        expectRequest(sut.perform(request), toCompleteWith: .failure(AuthenticatedHTTPClient.AuthError.unauthorized)) {
            client.complete(withStatusCode: 401)
            client.complete(withStatusCode: 401, at: 1)
        }

        wait(for: [exp], timeout: 1.0)
    }
}

// MARK: - Helpers
extension AuthenticatedHTTPClientTests {
    private typealias SUT = (
        sut: AuthenticatedHTTPClient,
        client: HTTPClientSpy,
        accessTokenStore: MockTokenStore,
        refreshTokenStore: MockTokenStore
    )

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SUT {
        let client = HTTPClientSpy()
        let accessTokenStore = MockTokenStore()
        let refreshTokenStore = MockTokenStore()
        let tokenStorage = TokenStorage(
            accessTokenStore: accessTokenStore,
            refreshTokenStore: refreshTokenStore
        )

        let sut = AuthenticatedHTTPClient(
            client: client,
            signedRequestBuilder: { request in
                var signedRequest = request
                signedRequest.setValue("Bearer token", forHTTPHeaderField: "Authorization")
                return signedRequest
            },
            tokenStorage: tokenStorage,
            refreshRequest: anyURLRequest()
        )

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)

        return (sut, client, accessTokenStore, refreshTokenStore)
    }

    private func expectRequest(
        _ publisher: AnyPublisher<(Data, HTTPURLResponse), Error>,
        toCompleteWith expectedResult: Result<(Data, HTTPURLResponse), Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for completion")
        var receivedResult: Result<(Data, HTTPURLResponse), Error>?
        var cancellables = Set<AnyCancellable>()

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        receivedResult = .failure(error)
                    }
                    exp.fulfill()
                },
                receiveValue: { value in
                    receivedResult = .success(value)
                }
            )
            .store(in: &cancellables)

        action()

        wait(for: [exp], timeout: 1.0)

        switch (receivedResult, expectedResult) {
        case let (.success((receivedData, receivedResponse)), .success((expectedData, expectedResponse))):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            XCTAssertEqual(receivedResponse.statusCode, expectedResponse.statusCode, file: file, line: line)

        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)

        default:
            XCTFail(
                "Expected \(expectedResult), got \(String(describing: receivedResult)) instead",
                file: file,
                line: line
            )
        }
    }
}
