// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

public struct DomainEntity: StorableItem, Hashable {
    public let id: UUID
    let value: String
}
