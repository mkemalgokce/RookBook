// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import AuthenticationServices
import Foundation

class AppleAuthorizationController: NSObject {
    // MARK: - Nested Types
    private struct InvalidCredentialsError: Error {}

    // MARK: - Properties
    weak var delegate: AppleAuthorizationControllerDelegate?
    private lazy var controller: ASAuthorizationController = {
        let appleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleIDRequest.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [appleIDRequest])
        controller.delegate = self
        return controller
    }()

    // MARK: - Initializers
    convenience init(controller: ASAuthorizationController) {
        self.init()
        self.controller = controller
    }

    // MARK: - Internal Methods
    func performRequests() {
        controller.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleAuthorizationController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let credentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            delegate?.didCompleteWithAuthorization(authorization: credentials)
        } else {
            delegate?.didCompleteWithError(error: InvalidCredentialsError())
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        delegate?.didCompleteWithError(error: error)
    }
}
