// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import RookBookIOS
import UIKit

final class CompositionRoot {
    // MARK: - Constanst
    let baseURL = URL(string: "https://localhost")!

    // MARK: - Properties
    lazy var navigationController = NavigationController()
    lazy var appStateNavigator: AppStateNavigating = AppStateNavigator(
        navigationController: navigationController,
        appStateStore: appStateStore,
        viewControllerFactory: self
    )
    lazy var client: HTTPClient = URLSessionHTTPClient(session: .shared)
    lazy var tokenStore = TokenStorage(
        accessTokenStore: makeKeychainTokenStorage(for: "access-token"),
        refreshTokenStore: makeKeychainTokenStorage(for: "refresh-token")
    )
    lazy var authenticationService: AuthenticationServiceConformable = makeRemoteAuthenticationService()
    lazy var appStateStore: AppStateStore = UserDefaultsAppStateStore()

    // MARK: - Internal Methods
    func updateAppState(to state: AppState) {
        appStateStore.update(state)
        appStateNavigator.navigate()
    }

    func show(_ viewController: UIViewController) {
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    // MARK: - Private Methods
    private func makeKeychainTokenStorage(for identifier: String) -> TokenStorable {
        KeychainTokenStore(identifier: identifier)
    }

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
