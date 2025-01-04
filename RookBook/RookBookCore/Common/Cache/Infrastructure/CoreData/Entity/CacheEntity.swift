// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.
//

import CoreData
import Foundation

@objc(CacheEntity)
public class CacheEntity: NSManagedObject {
    // MARK: - Nested Types
    public struct Item: StorableItem, Hashable {
        public let id: String
        public let timestamp: Date
        public let items: [DataEntity.Item]

        public init(id: String, items: [DataEntity.Item], timestamp: Date) {
            self.id = id
            self.items = items
            self.timestamp = timestamp
        }
    }

    // MARK: - Properties
    @NSManaged public var id: String
    @NSManaged public var timestamp: Date
    @NSManaged public var items: NSOrderedSet
}

extension CacheEntity: CoreDataStorableItem {
    public func update(with domain: Item, in context: NSManagedObjectContext) {
        id = domain.id
        timestamp = domain.timestamp

        let dataEntities = domain.items.map { item -> DataEntity in
            let entity = DataEntity(context: context)
            entity.update(with: item, in: context)
            entity.cache = self
            return entity
        }

        items = NSOrderedSet(array: dataEntities)
    }

    public func toDomain() -> Item {
        let dataItems = items.array.compactMap { ($0 as? DataEntity)?.toDomain() }
        return Item(
            id: id,
            items: dataItems,
            timestamp: timestamp
        )
    }
}
