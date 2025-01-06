// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class DomainStoreDecoratorTests: XCTestCase {
    func test_save_convertsAndDelegatesModelToUnderlyingStore() throws {
        let (sut, store) = makeSUT()
        let domainModel = DomainModel(id: "test-id", value: "test-value")

        try sut.save(domainModel)

        XCTAssertEqual(store.savedModels.count, 1)
        XCTAssertEqual(store.savedModels.first?.id, "test-id")
        XCTAssertEqual(store.savedModels.first?.value, "test-value")
    }

    func test_loadAll_convertsAndReturnsAllModelsFromUnderlyingStore() throws {
        let (sut, store) = makeSUT()
        let localModels = [
            LocalModel(id: "id1", value: "value1"),
            LocalModel(id: "id2", value: "value2")
        ]
        store.stubbedModels = localModels

        let result = try sut.loadAll()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "id1")
        XCTAssertEqual(result[0].value, "value1")
        XCTAssertEqual(result[1].id, "id2")
        XCTAssertEqual(result[1].value, "value2")
    }

    func test_load_convertsAndReturnsModelForIdentifier() throws {
        let (sut, store) = makeSUT()
        let localModel = LocalModel(id: "test-id", value: "test-value")
        store.stubbedModel = localModel

        let result = try sut.load(for: "test-id")

        XCTAssertEqual(result.id, "test-id")
        XCTAssertEqual(result.value, "test-value")
        XCTAssertEqual(store.loadedIdentifier, "test-id")
    }

    func test_update_convertsAndDelegatesModelToUnderlyingStore() throws {
        let (sut, store) = makeSUT()
        let domainModel = DomainModel(id: "test-id", value: "updated-value")

        try sut.update(domainModel)

        XCTAssertEqual(store.updatedModels.count, 1)
        XCTAssertEqual(store.updatedModels.first?.id, "test-id")
        XCTAssertEqual(store.updatedModels.first?.value, "updated-value")
    }

    func test_delete_delegatesIdentifierToUnderlyingStore() throws {
        let (sut, store) = makeSUT()

        try sut.delete(for: "test-id")

        XCTAssertEqual(store.deletedIdentifiers, ["test-id"])
    }

    func test_deleteAll_delegatesToUnderlyingStore() throws {
        let (sut, store) = makeSUT()

        try sut.deleteAll()

        XCTAssertTrue(store.deleteAllCalled)
    }

    func test_underlyingStoreError_propagatesToClient() {
        let (sut, store) = makeSUT()
        let expectedError = NSError(domain: "test", code: 1)
        store.stubbedError = expectedError

        XCTAssertThrowsError(try sut.loadAll()) { error in
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    // MARK: - Helpers

    private struct LocalModel: Equatable {
        let id: String
        let value: String
    }

    private struct DomainModel: Equatable {
        let id: String
        let value: String
    }

    private class StoreSpy: Storable {
        var savedModels: [LocalModel] = []
        var updatedModels: [LocalModel] = []
        var deletedIdentifiers: [String] = []
        var deleteAllCalled = false
        var loadedIdentifier: String?

        var stubbedModels: [LocalModel] = []
        var stubbedModel: LocalModel?
        var stubbedError: Error?

        func save(_ item: LocalModel) throws {
            if let error = stubbedError { throw error }
            savedModels.append(item)
        }

        func loadAll() throws -> [LocalModel] {
            if let error = stubbedError { throw error }
            return stubbedModels
        }

        func load(for identifier: String) throws -> LocalModel {
            if let error = stubbedError { throw error }
            loadedIdentifier = identifier
            return stubbedModel ?? LocalModel(id: identifier, value: "")
        }

        func update(_ item: LocalModel) throws {
            if let error = stubbedError { throw error }
            updatedModels.append(item)
        }

        func delete(for identifier: String) throws {
            if let error = stubbedError { throw error }
            deletedIdentifiers.append(identifier)
        }

        func deleteAll() throws {
            if let error = stubbedError { throw error }
            deleteAllCalled = true
        }
    }

    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: DomainStoreDecorator<StoreSpy, DomainModel>, store: StoreSpy) {
        let store = StoreSpy()
        let sut = DomainStoreDecorator(
            underlyingStore: store,
            toDomainModel: { LocalModel in
                DomainModel(id: LocalModel.id, value: LocalModel.value)
            },
            toLocalModel: { DomainModel in
                LocalModel(id: DomainModel.id, value: DomainModel.value)
            }
        )
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
