// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

protocol ReusableCell {}

extension ReusableCell {
    static var identifier: String { String(describing: Self.self) }
}
