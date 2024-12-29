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
                    navigationController.show(makeSignUpViewController(), sender: self)
                },
                onSuccess: { [weak self] in
                    self?.appStateStore.update(.home)
                }
            )
    }

    func makeHomeViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }

    func makeOnboardingViewController() -> UIViewController {
        OnboardingUIComposer.composed(onCompletion: { [weak self] in
            guard let self else { return }
            appStateStore.update(.login)
            appStateNavigator.navigate()
        })
    }

    // MARK: - SignUpViewController
    private func makeSignUpViewController() -> UIViewController {
        SignUpUIComposer.composed(
            email: authenticationService.register,
            apple: authenticationService.register,
            onSignIn: { [weak self] in
                guard let self else { return }
                navigationController.popViewController(animated: true)
            },
            onSuccess: { [weak self] in
                self?.appStateStore.update(.home)
            }
        )
    }
}
