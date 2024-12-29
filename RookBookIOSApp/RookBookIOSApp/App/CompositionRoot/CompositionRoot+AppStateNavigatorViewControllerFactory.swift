// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import UIKit

extension CompositionRoot: AppStateNavigatorViewControllerFactory {
    func makeLoginViewController() -> UIViewController {
        SignInUIComposer
            .composed(
                emailSignInPublisher: authenticationService.login,
                appleSignInPublisher: authenticationService.login
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
}
