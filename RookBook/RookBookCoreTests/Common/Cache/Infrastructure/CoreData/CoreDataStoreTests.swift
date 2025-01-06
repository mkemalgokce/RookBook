// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class CoreDataStoreTests: XCTestCase {
    func test_init_loadsPersistentStore() throws {
        let store = try makeSUT()
        XCTAssertNotNil(store.context.persistentStoreCoordinator?.persistentStores.first)
    }

    func test_init_withInvalidModelName_throwsError() {
        XCTAssertThrowsError(try SUT(
            storeURL: URL(fileURLWithPath: "/dev/null"),
            modelName: "Invalid Model Name",
            in: Bundle(for: Self.self),
            contextQueue: .background
        )) { error in
            XCTAssertEqual(error as NSError, SUT.StoreError.modelNotFound as NSError)
        }
    }

    func test_init_withInvalidStoreURL_throwsError() {
        let invalidURL = URL(fileURLWithPath: "/dev")
        XCTAssertThrowsError(try SUT(
            storeURL: invalidURL,
            in: Bundle(for: Self.self),
            contextQueue: .background
        )) { error in
            XCTAssertEqual(error as NSError, SUT.StoreError.failedToLoadPersistentContainer(anyNSError()) as NSError)
        }
    }

    func test_init_withInvalidBundle_throwsError() {
        XCTAssertThrowsError(try SUT(
            storeURL: URL(fileURLWithPath: "/dev/null"),
            contextQueue: .background
        )) { error in
            XCTAssertEqual(error as NSError, SUT.StoreError.modelNotFound as NSError)
        }
    }

    func test_init_withQueueMain_setsMainQueue() throws {
        let store = try makeSUT()
        XCTAssertEqual(store.contextQueue, .main)
    }

    func test_save_changesArePersisted() throws {
        let store = try makeSUT()
        let entity = makeDomainEntity()

        try store.save(entity)

        let loaded = try store.loadAll()
        XCTAssertEqual(loaded, [entity])
    }

    func test_saveAll_changesArePersisted() throws {
        let store = try makeSUT()
        let entity1 = makeDomainEntity()
        let entity2 = makeDomainEntity()

        try store.saveAll([entity1, entity2])

        let loaded = try store.loadAll()
        XCTAssertEqual(Set(loaded), Set([entity1, entity2]))
    }

    func test_loadAll_whenEmpty_returnsEmptyArray() throws {
        let store = try makeSUT()

        let loaded = try store.loadAll()
        XCTAssertEqual(loaded, [])
    }

    func test_loadAll_whenNotEmpty_returnsAllEntities() throws {
        let store = try makeSUT()
        let entity1 = makeDomainEntity()
        let entity2 = makeDomainEntity()

        try store.save(entity1)
        try store.save(entity2)

        let loaded = try store.loadAll()
        XCTAssertEqual(loaded, [entity1, entity2])
    }

    func test_deleteAll_whenEmpty_doesNotThrow() throws {
        let store = try makeSUT()
        try store.deleteAll()
    }

    func test_deleteAll_whenNotEmpty_deletesAllEntities() throws {
        let store = try makeSUT()
        let entity1 = makeDomainEntity()
        let entity2 = makeDomainEntity()

        try store.save(entity1)
        try store.save(entity2)
        try store.deleteAll()

        let loaded = try store.loadAll()
        XCTAssertEqual(loaded, [])
    }

    func test_load_forIdentifier_whenEmpty_throwsError() throws {
        let store = try makeSUT()
        XCTAssertThrowsError(try store.load(for: UUID())) { error in
            XCTAssertEqual(error as NSError, SUT.StoreError.itemNotFound as NSError)
        }
    }

    func test_load_forIdentifier_whenNotEmpty_returnsEntity() throws {
        let store = try makeSUT()
        let entity = makeDomainEntity()
        try store.save(entity)

        let loaded = try store.load(for: entity.id)
        XCTAssertEqual(loaded, entity)
    }

    func test_delete_forIdentifier_whenEmpty_throwsError() throws {
        let store = try makeSUT()
        XCTAssertThrowsError(try store.delete(for: UUID())) { error in
            XCTAssertEqual(error as NSError, SUT.StoreError.itemNotFound as NSError)
        }
    }

    func test_delete_forIdentifier_whenNotEmpty_deletesEntity() throws {
        let store = try makeSUT()
        let entity = makeDomainEntity()
        try store.save(entity)

        try store.delete(for: entity.id)
    }

    func test_update_whenEmpty_throwsError() throws {
        let store = try makeSUT()
        let entity = makeDomainEntity()
        XCTAssertThrowsError(try store.update(entity)) { error in
            XCTAssertEqual(error as NSError, SUT.StoreError.itemNotFound as NSError)
        }
    }

    func test_update_whenNotEmpty_updatesEntity() throws {
        let store = try makeSUT()
        let entity = makeDomainEntity()
        try store.save(entity)

        let updatedEntity = DomainEntity(id: entity.id, value: "Updated")
        try store.update(updatedEntity)

        let loaded = try store.load(for: entity.id)
        XCTAssertEqual(loaded, updatedEntity)
    }

    // MARK: - Helpers
    private typealias SUT = CoreDataStore<TestEntity>
    private func makeSUT(file: StaticString = #file, line: UInt = #line) throws -> SUT {
        let store = try SUT(storeURL: temporaryStoreURL(), in: Bundle(for: Self.self), contextQueue: .main)
        trackForMemoryLeaks(store, file: file, line: line)
        return store
    }

    private func temporaryStoreURL() -> URL {
        URL(fileURLWithPath: "/dev/null")
    }

    private func makeDomainEntity() -> DomainEntity {
        DomainEntity(id: UUID(), value: "Test")
    }
}
