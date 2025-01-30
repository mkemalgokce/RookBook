// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore
import UIKit

extension CompositionRoot: AppStateNavigatorViewControllerFactory {
    func makeLoginViewController() -> UIViewController {
        let authenticationService = makeRemoteAuthenticationService()
        return SignInUIComposer
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
        let authenticationService = makeRemoteAuthenticationService()
        return SignUpUIComposer.composed(
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

    // MARK: - Factory Methods
    private func makeRemoteAuthenticationService() -> RemoteAuthenticationService {
        let signInURL = AuthEndpoint.login.url(baseURL: baseURL)
        let signUpURL = AuthEndpoint.register.url(baseURL: baseURL)
        let logoutURL = AuthEndpoint.logout.url(baseURL: baseURL)

        return RemoteAuthenticationService(
            client: client,
            buildSignInRequest: { DictionaryRequestBuilder.build(on: signInURL, from: $0, with: .post) },
            buildSignUpRequest: { DictionaryRequestBuilder.build(on: signUpURL, from: $0, with: .post) },
            buildLogoutRequest: { logoutURL.request(for: .post) },
            storage: tokenStore
        )
    }
}
