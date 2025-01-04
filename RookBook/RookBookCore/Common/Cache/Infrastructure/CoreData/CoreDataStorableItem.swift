// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import CoreData

public protocol CoreDataStorableItem: StorableItem, NSManagedObject {
    associatedtype Domain: StorableItem

    func update(with domain: Domain, in context: NSManagedObjectContext)
    func toDomain() -> Domain
}
