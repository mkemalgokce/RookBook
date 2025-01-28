// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import UIKit

extension CompositionRoot: AppStateNavigatorViewControllerFactory {
    func makeLoginViewController() -> UIViewController {
        SignInUIComposer
            .composed(
                emailSignInPublisher: authenticationService.login,
                appleSignInPublisher: authenticationService.login,
                onSignUp: { [weak self] in
                    guard let self else { return }
                    self.show(self.makeSignUpViewController())
                },
                onSuccess: { [weak self] in
                    self?.updateAppState(to: .home)
                }
            )
    }

    func makeHomeViewController() -> UIViewController {
        BookUIComposer.composed(
            loadBooks: <#T##() -> AnyPublisher<[Book], any Error>#>,
            loadImage: <#T##(URL) -> AnyPublisher<Data, any Error>#>,
            onSelection: <#T##(Book) -> Void#>
        )
    }

    func makeOnboardingViewController() -> UIViewController {
        OnboardingUIComposer.composed(onCompletion: { [weak self] in
            guard let self else { return }
            updateAppState(to: .login)
        })
    }

    // MARK: - SignUpViewController
    private func makeSignUpViewController() -> UIViewController {
        SignUpUIComposer.composed(
            email: authenticationService.register,
            apple: authenticationService.register,
            onSignIn: { [weak self] in
                guard let self else { return }
                self.show(makeLoginViewController())
            },
            onSuccess: { [weak self] in
                self?.updateAppState(to: .home)
            }
        )
    }
}
