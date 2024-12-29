// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

class ResourceViewSpy: ResourceView {
    private(set) var messages: [String] = []
    func display(_ viewModel: String) {
        messages.append(viewModel)
    }
}
