// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import AuthenticationServices

protocol AppleAuthorizationControllerDelegate: AnyObject {
    func didCompleteWithAuthorization(authorization: ASAuthorizationAppleIDCredential)
    func didCompleteWithError(error: Error)
}
