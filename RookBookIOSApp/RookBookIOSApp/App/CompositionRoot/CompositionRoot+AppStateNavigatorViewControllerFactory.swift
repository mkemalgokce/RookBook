// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore
import UIKit

extension CompositionRoot: AppStateNavigatorViewControllerFactory {
    func makeLoginViewController() -> UIViewController {
        SignInUIComposer
            .composed(
                emailSignInPublisher: mailAuthenticationService.login,
                appleSignInPublisher: mailAuthenticationService.login,
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
        let bookCompositeFactory = BookCompositeFactory(
            client: authenticatedClient,
            bookStore: bookStore,
            scheduler: scheduler
        )
        let imageLoaderFactory = ImageDataLoaderFactory(client: client, imageStore: imageStore, scheduler: scheduler)
        return BookUIComposer.composed(
            loadBooks: bookCompositeFactory.makeRemoteWithLocalFallbackLoader,
            loadImage: imageLoaderFactory.makeLocalImageLoaderWithRemoteFallback,
            onSelection: { _ in }
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
            email: mailAuthenticationService.register,
            apple: mailAuthenticationService.register,
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
