// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import CoreData
import RookBookCore
import RookBookIOS
import UIKit

final class CompositionRoot {
    // MARK: - Constanst
    let baseURL = URL(string: "http://localhost:3000/api")!
    lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
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
        accessTokenStore: KeychainTokenStore(identifier: "access-token"),
        refreshTokenStore: KeychainTokenStore(identifier: "refresh-token")
    )
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

    lazy var authenticatedClient: HTTPClient = {
        let client = AuthenticatedHTTPClient(
            client: client,
            signedRequestBuilder: signRequest,
            tokenStorage: tokenStore,
            refreshRequest: refreshRequest
        )

        client.unauthorizedHandler = { [weak self] in
            self?.updateAppState(to: .login)
        }
        return client
    }()

    private var accessToken: String {
        (try? tokenStore.accessTokenStore.get().value) ?? ""
    }

    private var refreshToken: String {
        (try? tokenStore.refreshTokenStore.get().value) ?? ""
    }

    // MARK: - Internal Methods
    func updateAppState(to state: AppState) {
        appStateStore.update(state)
        appStateNavigator.navigate()
    }

    func show(_ viewController: UIViewController) {
        navigationController.setViewControllers([viewController], animated: true)
    }

    // MARK: - Private Methods
    private func signRequest(_ request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("refreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        return request
    }

    private func refreshRequest() -> URLRequest {
        var request = baseURL.appendingPathComponent("auth/refresh").request(for: .post)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("refreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        return request
    }
}
