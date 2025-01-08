// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public final class BookCompositeFactory<Store: BookStore> {
    // MARK: - Properties
    let client: HTTPClient
    let bookStore: Store
    let scheduler: AnyDispatchQueueScheduler

    lazy var localRepository: LocalRepository<Store> = LocalRepository(store: bookStore)

    // MARK: - Initializers
    init(client: HTTPClient, bookStore: Store, scheduler: AnyDispatchQueueScheduler) {
        self.client = client
        self.bookStore = bookStore
        self.scheduler = scheduler
    }
}
