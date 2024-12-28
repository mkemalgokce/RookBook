// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

final class AppStateNavigator: AppStateNavigating {
    let navigationController: UINavigationController
    let appStateStore: AppStateStore

    init(navigationController: UINavigationController, appStateStore: AppStateStore) {
        self.navigationController = navigationController
        self.appStateStore = appStateStore
    }

    func navigate() {
        let state = appStateStore.state()
        switch state {
        case .onboarding:
            show(viewController: makeOnboardingViewController())
        case .login:
            show(viewController: makeLoginViewController())
        case .home:
            show(viewController: makeHomeViewController())
        }
    }

    // MARK: - Helpers
    private func makeOnboardingViewController() -> UIViewController {
        OnboardingUIComposer.composed { [weak self] in
            self?.appStateStore.update(.login)
            self?.navigate()
        }
    }

    private func makeLoginViewController() -> UIViewController {
        // TODO: Implement
        let vc = UIViewController()
        vc.view.backgroundColor = .systemRed
        return vc
    }

    private func makeHomeViewController() -> UIViewController {
        // TODO: Implement
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGreen
        return vc
    }

    private func show(viewController: UIViewController) {
        navigationController.setViewControllers([viewController], animated: true)
    }
}
