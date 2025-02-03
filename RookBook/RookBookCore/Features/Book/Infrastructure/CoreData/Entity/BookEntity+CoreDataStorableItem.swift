// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import CoreData

extension BookEntity: CoreDataStorableItem {
    public func update(with domain: LocalBook, in context: NSManagedObjectContext) {
        id = domain.id
        title = domain.title
        author = domain.author
        coverURL = domain.coverURL
        pageCount = Int16(domain.pageCount)
        currentPage = Int16(domain.currentPage)
        lastReadAt = domain.lastReadAt
        isFavorite = domain.isFavorite
        cacheTimestamp = domain.cacheTimestamp
    }

    public func toLocal() -> LocalBook {
        LocalBook(
            id: id,
            title: title,
            description: desc,
            author: author,
            coverURL: coverURL,
            pageCount: Int(pageCount),
            currentPage: Int(currentPage),
            lastReadAt: lastReadAt,
            isFavorite: isFavorite,
            cacheTimestamp: cacheTimestamp
        )
    }
}
