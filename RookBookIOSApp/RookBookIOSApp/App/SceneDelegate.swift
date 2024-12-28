// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore
import RookBookIOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    var window: UIWindow?

    lazy var appStateNavigator: AppStateNavigating = AppStateNavigator(
        navigationController: navigationController,
        appStateStore: appStateStore
    )

    lazy var appStateStore: AppStateStore = UserDefaultsAppStateStore()

    lazy var navigationController = UINavigationController()

    // MARK: - Internal Methods
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appStateNavigator.navigate()
    }
}
