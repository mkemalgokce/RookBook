// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import CoreData

public final class CoreDataStore<CoreDataItem: CoreDataStorableItem>: Storable {
    // MARK: - Type Aliases
    public typealias Domain = CoreDataItem.Domain

    // MARK: - Nested Types
    public enum StoreError: Error {
        case itemNotFound
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    public enum ContextQueue {
        case main
        case background
    }

    // MARK: - Properties
    public var contextQueue: ContextQueue { context == container.viewContext ? .main : .background }
    public let context: NSManagedObjectContext

    private let container: NSPersistentContainer

    // MARK: - Initializers
    public init(
        storeURL: URL,
        modelName: String? = nil,
        in bundle: Bundle? = nil,
        contextQueue: ContextQueue = .background
    ) throws {
        let modelName = modelName ?? String(describing: CoreDataItem.self)
        guard let model = NSManagedObjectModel.with(name: modelName, in: bundle ?? Bundle(for: Self.self)) else {
            throw StoreError.modelNotFound
        }

        do {
            container = try NSPersistentContainer.load(name: modelName, model: model, url: storeURL)
            context = contextQueue == .main ? container.viewContext : container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    // MARK: - Public Methods
    public func save(_ item: Domain) throws {
        let model = CoreDataItem(context: context)
        model.update(with: item)
        try saveContext()
    }

    public func loadAll() throws -> [Domain] {
        let fetchRequest = NSFetchRequest<CoreDataItem>(entityName: String(describing: CoreDataItem.self))
        let models = try context.fetch(fetchRequest)
        return models.map { $0.toDomain() }
    }

    public func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreDataItem.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try saveContext()
    }

    public func load(for identifier: Item.Identifier) throws -> Domain {
        let model = try findModel(for: identifier)
        return model.toDomain()
    }

    public func delete(for identifier: Item.Identifier) throws {
        let model = try findModel(for: identifier)
        context.delete(model)
        try saveContext()
    }

    public func update(_ item: Item) throws {
        let model = try findModel(for: item.id)
        model.update(with: item)
        try saveContext()
    }

    // MARK: - Save Context
    private func findModel(for identifier: Item.Identifier) throws -> CoreDataItem {
        let fetchRequest = NSFetchRequest<CoreDataItem>(entityName: String(describing: CoreDataItem.self))
        fetchRequest.predicate = NSPredicate(format: "id == %@", identifier.stringValue)
        guard let model = try context.fetch(fetchRequest).first else {
            throw StoreError.itemNotFound
        }
        return model
    }

    private func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
