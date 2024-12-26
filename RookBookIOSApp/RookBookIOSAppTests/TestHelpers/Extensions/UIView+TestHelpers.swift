// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
