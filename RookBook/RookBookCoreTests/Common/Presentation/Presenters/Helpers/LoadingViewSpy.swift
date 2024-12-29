// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

class LoadingViewSpy: ResourceLoadingView {
    private(set) var messages: [ResourceLoadingViewModel] = []
    func display(_ viewModel: ResourceLoadingViewModel) {
        messages.append(viewModel)
    }
}
