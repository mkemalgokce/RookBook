// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.
//

import CoreData
import Foundation

@objc(BookEntity)
public class BookEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var author: String
    @NSManaged public var coverURL: URL?
    @NSManaged public var pageCount: Int16
    @NSManaged public var currentPage: Int16
    @NSManaged public var lastReadAt: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var cacheTimestamp: Date
}
