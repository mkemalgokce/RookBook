// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import CoreData
import RookBookCore
import RookBookIOS
import UIKit

final class CompositionRoot {
    // MARK: - Constanst
    let baseURL = URL(string: "https://verdant-pen-production.up.railway.app/api")!
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.mkg.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()

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

    lazy var bookStore: AnyStorable<LocalBook, UUID> = {
        let store = try! CoreDataStore<BookEntity>(storeURL:
            NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("book-store.sqlite"), contextQueue: .background)
        return AnyStorable<LocalBook, UUID>(store)
    }()

    lazy var imageStore: AnyStorable<LocalData, URL> = {
        let store = try! CoreDataStore<DataEntity>(storeURL:
            NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("image-store.sqlite"), contextQueue: .background)
        return AnyStorable<LocalData, URL>(store)
    }()

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

    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalRepository(store: imageStore)

        return localImageLoader
            .fetch(with: url)
            .map(\.data)
            .fallback(to: { [client, scheduler, imageStore] in
                client
                    .perform(url.request())
                    .tryMap(DataResponseMapper().map)
                    .caching(to: imageStore, map: { LocalData(id: url, data: $0) })
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
