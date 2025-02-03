// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import CoreData

public protocol CoreDataStorableItem: StorableItem, NSManagedObject {
    associatedtype Local: StorableItem

    func update(with local: Local, in context: NSManagedObjectContext)
    func toLocal() -> Local
}
