// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

final class EmailAuthenticationService: AuthenticationService {
    // MARK: - Properties
    private let client: HTTPClient
    private let buildSignInRequest: (Credentials) -> URLRequest
    private let buildSignUpRequest: (Credentials) -> URLRequest
    private let buildLogoutRequest: () -> URLRequest
    private let storage: TokenStorage

    // MARK: - Initializers
    init(
        client: HTTPClient,
        buildSignInRequest: @escaping (Credentials) -> URLRequest,
        buildSignUpRequest: @escaping (Credentials) -> URLRequest,
        buildLogoutRequest: @escaping () -> URLRequest,
        storage: TokenStorage
    ) {
        self.client = client
        self.buildSignInRequest = buildSignInRequest
        self.buildSignUpRequest = buildSignUpRequest
        self.buildLogoutRequest = buildLogoutRequest
        self.storage = storage
    }

    // MARK: - Internal Methods
    func login(with credentials: SignInCredentials) -> AnyPublisher<AuthenticatedUser, any Error> {
        let request = buildSignInRequest(credentials)
        let storage = storage
        return client.perform(request)
            .tryMap { data, response in
                let mapper = AuthenticationResponseMapper()
                let authResponse = try mapper.map(data: data, from: response)
                try storage.storeTokens(accessToken: authResponse.accessToken, refreshToken: authResponse.refreshToken)
                let user = AuthenticatedUserMapper.map(authResponse.user)
                return user
            }
            .eraseToAnyPublisher()
    }

    func register(with credentials: SignUpCredentials) -> AnyPublisher<AuthenticatedUser, any Error> {
        let request = buildSignUpRequest(credentials)
        let storage = storage
        return client.perform(request)
            .tryMap { data, response in
                let mapper = AuthenticationResponseMapper()
                let authResponse = try mapper.map(data: data, from: response)
                try storage.storeTokens(accessToken: authResponse.accessToken, refreshToken: authResponse.refreshToken)
                let user = AuthenticatedUserMapper.map(authResponse.user)
                return user
            }
            .eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Void, any Error> {
        let request = buildLogoutRequest()
        let storage = storage
        return client.perform(request)
            .tryMap { data, response in
                let mapper = EmptyResponseMapper()
                try mapper.map(data: data, from: response)
                try storage.clearStores()
            }
            .eraseToAnyPublisher()
    }
}
