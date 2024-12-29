// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation
import RookBookCore
import RookBookIOS

enum SignUpUIComposer {
    // MARK: - Typealiases
    typealias SignUpPublisher = (SignUpCredentials) -> AnyPublisher<AuthenticatedUser, Error>

    // MARK: - Static Methods
    static func composed(email emailSignUpPublisher: @escaping SignUpPublisher,
                         apple appleSignUpPublisher: @escaping SignUpPublisher,
                         onSignIn: @escaping () -> Void,
                         onSuccess: @escaping () -> Void) -> SignUpViewController {
        let vc = SignUpViewController.make(with: SignUpPresenter.textConfiguration)
        let weakVC = WeakRef(vc)

        let presenter = LoadResourcePresenter(errorView: weakVC, loadingView: weakVC)
        let signUpView = SignUpViewAdapter(controller: vc)
        signUpView.onDisplay = onSuccess

        vc.onSignUp = { [weak vc] in
            guard let vc else { return }
            presenter.load(on: signUpView) { vc.emailSignUpProcess(with: emailSignUpPublisher) }
        }
        vc.onAppleSignUp = { [weak vc] in
            guard let vc else { return }
            presenter.load(on: signUpView) { vc.appleSignInProcess(with: appleSignUpPublisher) }
        }
        vc.onSignIn = onSignIn
        return vc
    }
}

// MARK: - SignUpViewController Extension
extension SignUpViewController {
    fileprivate static func make(with textConfiguration: SignUpViewTextConfiguration) -> SignUpViewController {
        let viewController = SignUpViewController()
        viewController.setup(with: textConfiguration)
        viewController.appleCredentialsProvider = AppleCredentialsProvider()
        return viewController
    }

    private var credentials: AnyPublisher<SignUpCredentials, Error> {
        guard let fullNameText, let mailText, let passwordText,
              [fullNameText, mailText, passwordText].allSatisfy({ !$0.isEmpty }) else {
            return Empty().eraseToAnyPublisher()
        }

        return Just(EmailSignUpCredentials(name: fullNameText, email: mailText, password: passwordText))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    private var appleCredentials: AnyPublisher<AppleCredentials, Error> {
        appleCredentialsProvider.provide()
    }

    fileprivate func emailSignUpProcess(with publisher: @escaping SignUpUIComposer
        .SignUpPublisher) -> AnyPublisher<AuthenticatedUser, Error> {
        credentials.flatMap(publisher).eraseToAnyPublisher()
    }

    fileprivate func appleSignInProcess(with publisher: @escaping SignUpUIComposer
        .SignUpPublisher) -> AnyPublisher<AuthenticatedUser, Error> {
        appleCredentials.flatMap(publisher).eraseToAnyPublisher()
    }
}
