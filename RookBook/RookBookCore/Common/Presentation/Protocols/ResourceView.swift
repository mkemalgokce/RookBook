// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol ResourceView {
    associatedtype ViewModel
    func display(_ viewModel: ViewModel)
}
