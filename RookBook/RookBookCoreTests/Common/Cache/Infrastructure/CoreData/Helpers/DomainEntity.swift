// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

public struct DomainEntity: StorableItem, Equatable {
    public let id: UUID
    let value: String
}
