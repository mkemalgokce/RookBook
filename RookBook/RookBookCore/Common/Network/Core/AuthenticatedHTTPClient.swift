// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public final class AuthenticatedHTTPClient: HTTPClient {
    // MARK: - Nested Types
    enum AuthError: Error {
        case unauthorized
    }

    // MARK: - Properties
    public var unauthorizedHandler: (() -> Void)?

    private let client: HTTPClient
    private let signedRequestBuilder: (URLRequest) -> URLRequest
    private let tokenStorage: TokenStorage
    private let refreshRequest: () -> URLRequest

    // MARK: - Initializers
    public init(
        client: HTTPClient,
        signedRequestBuilder: @escaping (URLRequest) -> URLRequest,
        tokenStorage: TokenStorage,
        refreshRequest: @escaping () -> URLRequest
    ) {
        self.client = client
        self.signedRequestBuilder = signedRequestBuilder
        self.tokenStorage = tokenStorage
        self.refreshRequest = refreshRequest
    }

    // MARK: - Public Methods
    public func perform(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        let signedRequest = signedRequestBuilder(request)
        return client.perform(signedRequest)
            .refreshAndRetry(
                client: client,
                tokenStorage: tokenStorage,
                refreshRequest: refreshRequest(),
                request: { [signedRequestBuilder] in signedRequestBuilder(request) }
            )
            .dispatchOnMainThread()
            .catch { [weak self] error in
                if let authError = error as? AuthError, authError == .unauthorized {
                    self?.unauthorizedHandler?()
                }
                return Fail(outputType: (Data, HTTPURLResponse).self, failure: error)
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == (Data, HTTPURLResponse), Failure == Error {
    fileprivate func refreshAndRetry(
        client: HTTPClient,
        tokenStorage: TokenStorage,
        refreshRequest: URLRequest,
        request: @escaping () -> URLRequest
    ) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        flatMap { data, response -> AnyPublisher<(Data, HTTPURLResponse), Error> in
            if response.statusCode == 401 {
                return client.perform(refreshRequest)
                    .tryMap { data, response in
                        if response.statusCode == 401 {
                            throw AuthenticatedHTTPClient.AuthError.unauthorized
                        }
                        let authenticationResponse = try AuthenticationResponseMapper().map(
                            data: data,
                            from: response
                        )
                        try tokenStorage
                            .storeTokens(
                                accessToken: authenticationResponse.accessToken,
                                refreshToken: authenticationResponse.refreshToken
                            )
                    }
                    .flatMap { _ in
                        client.perform(request())
                    }
                    .eraseToAnyPublisher()
            } else {
                return Just((data, response))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}
