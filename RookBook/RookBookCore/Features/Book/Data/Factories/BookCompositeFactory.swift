// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public final class BookCompositeFactory {
    // MARK: - Properties
    let client: HTTPClient
    let bookStore: AnyStorable<LocalBook, UUID>
    let scheduler: AnyDispatchQueueScheduler

    lazy var localRepository: LocalRepository<AnyStorable<LocalBook, UUID>> = LocalRepository(store: bookStore)

    // MARK: - Initializers
    public init(client: HTTPClient, bookStore: AnyStorable<LocalBook, UUID>, scheduler: AnyDispatchQueueScheduler) {
        self.client = client
        self.bookStore = bookStore
        self.scheduler = scheduler
    }
}
