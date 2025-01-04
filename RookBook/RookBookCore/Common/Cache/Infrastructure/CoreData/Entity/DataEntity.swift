// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.
//

import CoreData
import Foundation

@objc(DataEntity)
public class DataEntity: NSManagedObject {
    // MARK: - Nested Types
    public struct Item: StorableItem, Hashable {
        public let id: UUID
        public let data: Data

        public init(id: UUID = UUID(), data: Data) {
            self.id = id
            self.data = data
        }

        func toDomain<Domain: Decodable>(decodingType: Domain.Type) throws -> Domain {
            try JSONDecoder().decode(decodingType, from: data)
        }
    }

    // MARK: - Properties
    @NSManaged public var id: UUID
    @NSManaged public var data: Data
    @NSManaged public var cache: CacheEntity
}

extension DataEntity: CoreDataStorableItem {
    public func update(with domain: Item, in context: NSManagedObjectContext) {
        id = domain.id
        data = domain.data
    }

    public func toDomain() -> Item {
        Item(
            id: id,
            data: data
        )
    }
}
