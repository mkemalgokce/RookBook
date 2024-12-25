// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol ResponseMapping {
    associatedtype MappedType
    func map(data: Data, from response: HTTPURLResponse) throws -> MappedType
}
