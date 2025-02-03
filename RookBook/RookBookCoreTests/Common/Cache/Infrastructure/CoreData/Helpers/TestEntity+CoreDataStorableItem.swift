// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import CoreData
import RookBookCore

extension TestEntity: CoreDataStorableItem {
    public func update(with domain: DomainEntity, in context: NSManagedObjectContext) {
        id = domain.id
        value = domain.value
    }

    public func toLocal() -> DomainEntity {
        DomainEntity(id: id, value: value)
    }
}
