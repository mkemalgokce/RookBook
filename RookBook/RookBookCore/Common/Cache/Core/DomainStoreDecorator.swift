// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

final class DomainStoreDecorator<UnderlyingStore: Storable, DomainModel>: Storable {
    // MARK: - Type Aliases
    typealias LocalModel = UnderlyingStore.Item
    typealias StoreIdentifier = UnderlyingStore.Identifier

    // MARK: - Properties
    private let underlyingStore: UnderlyingStore
    private let toDomainModel: (LocalModel) -> DomainModel
    private let toLocalModel: (DomainModel) -> LocalModel

    // MARK: - Initializer
    init(
        underlyingStore: UnderlyingStore,
        toDomainModel: @escaping (LocalModel) -> DomainModel,
        toLocalModel: @escaping (DomainModel) -> LocalModel
    ) {
        self.underlyingStore = underlyingStore
        self.toDomainModel = toDomainModel
        self.toLocalModel = toLocalModel
    }

    // MARK: - Storable Protocol Implementation
    func save(_ domainModel: DomainModel) throws {
        let localModel = toLocalModel(domainModel)
        try underlyingStore.save(localModel)
    }

    func saveAll(_ items: [DomainModel]) throws {
        let localModels = items.map { toLocalModel($0) }
        try underlyingStore.saveAll(localModels)
    }

    func loadAll() throws -> [DomainModel] {
        let localModels = try underlyingStore.loadAll()
        return localModels.map { toDomainModel($0) }
    }

    func load(for identifier: StoreIdentifier) throws -> DomainModel {
        let localModel = try underlyingStore.load(for: identifier)
        return toDomainModel(localModel)
    }

    func update(_ domainModel: DomainModel) throws {
        let localModel = toLocalModel(domainModel)
        try underlyingStore.update(localModel)
    }

    func delete(for identifier: StoreIdentifier) throws {
        try underlyingStore.delete(for: identifier)
    }

    func deleteAll() throws {
        try underlyingStore.deleteAll()
    }
}
