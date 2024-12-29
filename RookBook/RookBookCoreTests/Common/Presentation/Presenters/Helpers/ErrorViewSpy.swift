// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

class ErrorViewSpy: ResourceErrorView {
    private(set) var messages: [ResourceErrorViewModel] = []
    func display(_ viewModel: ResourceErrorViewModel) {
        messages.append(viewModel)
    }
}
