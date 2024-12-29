// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore

final class AuthenticationServiceSpy: AuthenticationServiceConformable {
    // MARK: - Nested Types
    enum Message {
        case login(credentials: RookBookCore.SignInCredentials)
        case register(credentials: RookBookCore.SignUpCredentials)
        case logout
    }

    // MARK: - Properties
    private(set) var messages = [Message]()

    // MARK: - Stub Results
    var loginResult: Result<AuthenticatedUser, Error> = .failure(anyNSError())
    var registerResult: Result<AuthenticatedUser, Error> = .failure(anyNSError())
    var logoutResult: Result<Void, Error> = .success(())

    // MARK: - AuthenticationServiceConformable
    func login(with credentials: any RookBookCore
        .SignInCredentials) -> AnyPublisher<RookBookCore.AuthenticatedUser, any Error> {
        messages.append(.login(credentials: credentials))
        return loginResult.publisher
            .eraseToAnyPublisher()
    }

    func register(with credentials: any RookBookCore
        .SignUpCredentials) -> AnyPublisher<RookBookCore.AuthenticatedUser, any Error> {
        messages.append(.register(credentials: credentials))
        return registerResult.publisher
            .eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Void, any Error> {
        messages.append(.logout)
        return logoutResult.publisher
            .eraseToAnyPublisher()
    }
}

// MARK: - Equatable
extension AuthenticationServiceSpy.Message: Equatable {
    static func ==(lhs: AuthenticationServiceSpy.Message, rhs: AuthenticationServiceSpy.Message) -> Bool {
        switch (lhs, rhs) {
        case (.logout, .logout):
            return true
        case let (.login(lhsCredentials), .login(rhsCredentials)):
            if let lhsCredentials = lhsCredentials as? AnyHashable,
               let rhsCredentials = rhsCredentials as? AnyHashable {
                return lhsCredentials == rhsCredentials
            }
            return false
        case let (.register(lhsCredentials), .register(rhsCredentials)):
            if let lhsCredentials = lhsCredentials as? AnyHashable,
               let rhsCredentials = rhsCredentials as? AnyHashable {
                return lhsCredentials == rhsCredentials
            }
            return false
        default:
            return false
        }
    }
}
