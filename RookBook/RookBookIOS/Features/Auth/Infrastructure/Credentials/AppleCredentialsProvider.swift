// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import AuthenticationServices
import Combine
import RookBookCore

class AppleCredentialsProvider: NSObject, AppleCredentialsProviding {
    // MARK: - Nested Types
    enum AppleCredentialsError: Error {
        case invalidCredentials
    }

    // MARK: - Properties
    private let subject = PassthroughSubject<RookBookCore.AppleCredentials, any Error>()
    private let authorizationController: AppleAuthorizationController

    // MARK: - Initializers
    init(authorizationController: AppleAuthorizationController? = nil) {
        self.authorizationController = authorizationController ?? AppleAuthorizationController()
        super.init()
        self.authorizationController.delegate = self
    }

    // MARK: - AppleCredentialsProviding
    func provide() -> AnyPublisher<RookBookCore.AppleCredentials, any Error> {
        authorizationController.performRequests()
        return subject.eraseToAnyPublisher()
    }

    // MARK: - Private Methods
    private func handleAuthorizationSuccess(_ credentials: ASAuthorizationAppleIDCredential) {
        let formatter = PersonNameComponentsFormatter()
        let fullName = credentials.fullName.flatMap { formatter.string(from: $0) }

        let appleCredentials = AppleCredentials(
            userIdentifier: credentials.user,
            email: credentials.email,
            fullName: fullName,
            authorizationCode: credentials.authorizationCode,
            identityToken: credentials.identityToken
        )

        subject.send(appleCredentials)
        subject.send(completion: .finished)
    }

    private func handleAuthorizationFailure(_ error: Error) {
        subject.send(completion: .failure(error))
    }
}

// MARK: - AppleAuthorizationControllerDelegate
extension AppleCredentialsProvider: AppleAuthorizationControllerDelegate {
    func didCompleteWithAuthorization(authorization: ASAuthorizationAppleIDCredential) {
        handleAuthorizationSuccess(authorization)
    }

    func didCompleteWithError(error: any Error) {
        handleAuthorizationFailure(error)
    }
}
