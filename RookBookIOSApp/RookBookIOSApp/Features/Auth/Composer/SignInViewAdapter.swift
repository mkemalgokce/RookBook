// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore
import RookBookIOS

final class SignInViewAdapter: ResourceView {
    weak var controller: SignInViewController?

    init(controller: SignInViewController? = nil) {
        self.controller = controller
    }

    func display(_ viewModel: AuthenticatedUser) {}
}
