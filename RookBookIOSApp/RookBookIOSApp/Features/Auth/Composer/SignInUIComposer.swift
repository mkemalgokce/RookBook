// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore
import RookBookIOS

enum SignInUIComposer {
    // MARK: - Typealiases
    typealias SignInPublisher = (SignInCredentials) -> AnyPublisher<AuthenticatedUser, Error>

    // MARK: - Static Methods
    static func composed(
        emailSignInPublisher: @escaping SignInPublisher,
        appleSignInPublisher: @escaping SignInPublisher,
        onSignUp: @escaping () -> Void,
        onSuccess: @escaping () -> Void
    ) -> SignInViewController {
        let vc = SignInViewController.make(with: SignInPresenter.textConfiguration)
        let presenter = LoadResourcePresenter(errorView: WeakRef(vc), loadingView: WeakRef(vc))
        let signInView = SignInViewAdapter(controller: vc)
        signInView.onDisplay = onSuccess

        vc.onSignIn = { [weak vc] in
            guard let vc else { return }
            presenter.load(on: signInView) { vc.emailSignInProcess(with: emailSignInPublisher) }
        }
        vc.onAppleSignIn = { [weak vc] in
            guard let vc else { return }
            presenter.load(on: signInView) { vc.appleSignInProcess(with: appleSignInPublisher) }
        }
        vc.onSignUp = onSignUp

        return vc
    }
}

// MARK: - SignInViewController Extension
extension SignInViewController {
    fileprivate static func make(with textConfiguration: SignInViewTextConfiguration) -> SignInViewController {
        let viewController = SignInViewController()
        viewController.setup(with: textConfiguration)
        viewController.appleCredentialsProvider = AppleCredentialsProvider()
        return viewController
    }

    private var credentials: AnyPublisher<SignInCredentials, Error> {
        guard let mailText, let passwordText, !mailText.isEmpty, !passwordText.isEmpty else {
            return Empty().eraseToAnyPublisher()
        }
        return Just(EmailSignInCredentials(email: mailText, password: passwordText))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    private var appleCredentials: AnyPublisher<AppleCredentials, Error> {
        appleCredentialsProvider.provide()
    }

    fileprivate func emailSignInProcess(with publisher: @escaping SignInUIComposer
        .SignInPublisher) -> AnyPublisher<AuthenticatedUser, Error> {
        credentials.flatMap(publisher).eraseToAnyPublisher()
    }

    fileprivate func appleSignInProcess(with publisher: @escaping SignInUIComposer
        .SignInPublisher) -> AnyPublisher<AuthenticatedUser, Error> {
        appleCredentials.flatMap(publisher).eraseToAnyPublisher()
    }
}
