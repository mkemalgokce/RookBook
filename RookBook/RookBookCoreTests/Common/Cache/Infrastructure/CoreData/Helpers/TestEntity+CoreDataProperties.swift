// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.
//

import CoreData
import Foundation

extension TestEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var value: String
}
