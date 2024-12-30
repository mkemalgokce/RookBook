// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore
import RookBookIOS

final class SignUpViewAdapter: ResourceView {
    // MARK: - Properties
    weak var controller: SignUpViewController?
    var onDisplay: (() -> Void)?

    // MARK: - Initializers
    init(controller: SignUpViewController? = nil) {
        self.controller = controller
    }

    // MARK: - Internal Methods
    func display(_ viewModel: AuthenticatedUser) {
        onDisplay?()
    }
}
