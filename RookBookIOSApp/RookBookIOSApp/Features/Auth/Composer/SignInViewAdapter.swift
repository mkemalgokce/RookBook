// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore
import RookBookIOS

final class SignInViewAdapter: ResourceView {
    // MARK: - Propertiess
    weak var controller: SignInViewController?
    var onDisplay: (() -> Void)?

    // MARK: - Initializers
    init(controller: SignInViewController? = nil) {
        self.controller = controller
    }

    // MARK: - Internal Methods
    func display(_ viewModel: AuthenticatedUser) {
        onDisplay?()
    }
}
