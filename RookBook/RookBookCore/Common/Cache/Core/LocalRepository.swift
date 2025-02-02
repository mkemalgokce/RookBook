// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public final class LocalRepository<Store: Storable>: Repository {
    // MARK: - Properties
    private let store: Store

    // MARK: - Initializers
    public init(store: Store) {
        self.store = store
    }

    // MARK: - Public Methods
    public func fetch() -> AnyPublisher<[Store.Item], any Error> {
        store.loadAllPublisher()
    }

    public func fetch(with id: Store.Identifier) -> AnyPublisher<Store.Item, any Error> {
        store.loadPublisher(for: id)
    }

    public func save(_ entity: Store.Item) -> AnyPublisher<Void, any Error> {
        store.savePublisher(entity)
    }

    public func delete(with id: Store.Identifier) -> AnyPublisher<Void, any Error> {
        store.deletePublisher(for: id)
    }

    public func update(_ entity: Store.Item) -> AnyPublisher<Void, any Error> {
        store.updatePublisher(entity)
    }

    public func deleteAll() -> AnyPublisher<Void, any Error> {
        store.deleteAllPublisher()
    }
}
