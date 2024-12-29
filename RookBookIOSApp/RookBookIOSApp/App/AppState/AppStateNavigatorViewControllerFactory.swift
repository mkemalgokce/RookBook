// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

protocol AppStateNavigatorViewControllerFactory {
    func makeLoginViewController() -> UIViewController
    func makeHomeViewController() -> UIViewController
    func makeOnboardingViewController() -> UIViewController
}
