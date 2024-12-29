// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore
import RookBookIOS

enum SignInUIComposer {
    typealias SignInPublisher = (SignInCredentials) -> AnyPublisher<AuthenticatedUser, Error>

    static func composed(
        emailSignInPublisher: @escaping SignInPublisher,
        appleSignInPublisher: @escaping SignInPublisher
    ) -> SignInViewController {
        let vc = SignInViewController.make(with: SignInPresenter.textConfiguration)
        let weakVC = WeakRef(vc)
        let presenter = LoadResourcePresenter(errorView: weakVC, loadingView: weakVC)
        let signInView = SignInViewAdapter(controller: vc)

        configureSignInHandlers(
            for: vc,
            with: presenter,
            signInView: signInView,
            emailSignInPublisher: emailSignInPublisher,
            appleSignInPublisher: appleSignInPublisher
        )

        return vc
    }

    // MARK: - Private Helpers
    private static func configureSignInHandlers(
        for vc: SignInViewController,
        with presenter: LoadResourcePresenter,
        signInView: SignInViewAdapter,
        emailSignInPublisher: @escaping SignInPublisher,
        appleSignInPublisher: @escaping SignInPublisher
    ) {
        vc.onSignIn = { presenter.load(on: signInView) { vc.emailSignInProcess(with: emailSignInPublisher) } }
        vc.onAppleSignIn = { presenter.load(on: signInView) { vc.appleSignInProcess(with: appleSignInPublisher) } }
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
        guard let mailText, let passwordText else {
            return Empty().eraseToAnyPublisher()
        }
        return Just(EmailSignInCredentials(email: mailText, password: passwordText))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    private var appleCredentials: AnyPublisher<AppleCredentials, Error> {
        appleCredentialsProvider?.provide() ?? Empty().eraseToAnyPublisher()
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
