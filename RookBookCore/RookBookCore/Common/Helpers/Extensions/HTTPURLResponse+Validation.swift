// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

// MARK: - HTTPURLResponse+Validation
extension HTTPURLResponse {
    func hasValidStatusCode(in range: Range<Int> = 200..<300) -> Bool {
        range.contains(statusCode)
    }
}
