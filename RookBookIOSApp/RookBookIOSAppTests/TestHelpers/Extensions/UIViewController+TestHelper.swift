// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}
