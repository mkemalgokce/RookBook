// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import CoreData

extension DataEntity: CoreDataStorableItem {
    public func update(with local: LocalData, in context: NSManagedObjectContext) {
        id = local.id
        data = local.data
        cacheTimestamp = local.cacheTimestamp
    }

    public func toLocal() -> LocalData {
        LocalData(id: id, data: data, cacheTimestamp: cacheTimestamp)
    }
}
