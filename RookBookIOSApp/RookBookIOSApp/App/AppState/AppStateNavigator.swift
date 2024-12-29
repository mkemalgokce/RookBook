// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

final class AppStateNavigator: AppStateNavigating {
    let navigationController: UINavigationController
    let appStateStore: AppStateStore
    let viewControllerFactory: AppStateNavigatorViewControllerFactory

    init(
        navigationController: UINavigationController,
        appStateStore: AppStateStore,
        viewControllerFactory: AppStateNavigatorViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.appStateStore = appStateStore
        self.viewControllerFactory = viewControllerFactory
    }

    func navigate() {
        let state = appStateStore.state()
        switch state {
        case .onboarding:
            show(viewControllerFactory.makeOnboardingViewController())
        case .login:
            show(viewControllerFactory.makeLoginViewController())
        case .home:
            show(viewControllerFactory.makeHomeViewController())
        }
    }

    private func show(_ viewController: UIViewController) {
        navigationController.setViewControllers([viewController], animated: false)
    }
}
