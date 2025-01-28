// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.
//

import CoreData
import Foundation

@objc(DataEntity)
public class DataEntity: NSManagedObject {
    @NSManaged public var id: URL
    @NSManaged public var data: Data
    @NSManaged public var cacheTimestamp: Date
}
