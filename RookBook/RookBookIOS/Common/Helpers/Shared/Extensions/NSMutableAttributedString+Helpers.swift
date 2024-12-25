// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

extension NSMutableAttributedString {
    convenience init(strings: [NSAttributedString]) {
        self.init()
        for string in strings {
            append(string)
        }
    }
}
