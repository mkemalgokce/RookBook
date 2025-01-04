// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import CoreData
import XCTest

final class CacheEntityTests: XCTestCase {
    func test_toDomain_withValidData_mapsCorrectly() throws {
        let (sut, context) = try makeSUT()
        let timestamp = Date()
        let id = "test-id"
        let dataItems = [
            makeDataEntity(context: context, data: "item1".data(using: .utf8)!, cache: sut),
            makeDataEntity(context: context, data: "item2".data(using: .utf8)!, cache: sut)
        ]

        sut.id = id
        sut.timestamp = timestamp
        sut.items = NSOrderedSet(array: dataItems)

        // when
        let domain = sut.toDomain()

        // then
        XCTAssertEqual(domain.id, id)
        XCTAssertEqual(domain.timestamp, timestamp)
        XCTAssertEqual(domain.items.count, 2)
        XCTAssertEqual(domain.items[0].data, "item1".data(using: .utf8)!)
        XCTAssertEqual(domain.items[1].data, "item2".data(using: .utf8)!)
    }

    func test_update_updatesAllProperties() throws {
        let (sut, context) = try makeSUT()
        let timestamp = Date()
        let id = "test-id"
        let domainItems = [
            DataEntity.Item(data: "item1".data(using: .utf8)!),
            DataEntity.Item(data: "item2".data(using: .utf8)!)
        ]
        let domain = CacheEntity.Item(id: id, items: domainItems, timestamp: timestamp)

        sut.update(with: domain, in: context)

        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.timestamp, timestamp)
        XCTAssertEqual(sut.items.count, 2)

        let dataEntities = sut.items.array as! [DataEntity]
        XCTAssertEqual(dataEntities[0].data, "item1".data(using: .utf8)!)
        XCTAssertEqual(dataEntities[1].data, "item2".data(using: .utf8)!)
        XCTAssertEqual(dataEntities[0].cache, sut)
        XCTAssertEqual(dataEntities[1].cache, sut)
    }

    func test_toDomain_whenItemsArrayIsEmpty_returnsEmptyArray() throws {
        let (sut, _) = try makeSUT()
        sut.id = "test-id"
        sut.timestamp = Date()

        let domain = sut.toDomain()

        XCTAssertEqual(domain.items, [])
    }

    func test_toDomain_whenItemsArrayContainsInvalidType_returnsEmptyArray() throws {
        let (sut, _) = try makeSUT()
        sut.id = "test-id"
        sut.timestamp = Date()

        let domain = sut.toDomain()

        XCTAssertEqual(domain.items, [])
    }

    func test_toDomain_preservesItemsOrder() throws {
        let (sut, context) = try makeSUT()
        let items = [
            makeDataEntity(context: context, data: "item1".data(using: .utf8)!, cache: sut),
            makeDataEntity(context: context, data: "item2".data(using: .utf8)!, cache: sut),
            makeDataEntity(context: context, data: "item3".data(using: .utf8)!, cache: sut)
        ]

        sut.id = "test-id"
        sut.timestamp = Date()
        sut.items = NSOrderedSet(array: items)

        let domain = sut.toDomain()

        XCTAssertEqual(domain.items.map(\.data), items.map(\.data))
    }

    func test_update_preservesItemsIdentifiers() throws {
        let (sut, context) = try makeSUT()
        let itemIDs = [UUID(), UUID()]
        let domainItems = itemIDs.map { id in
            DataEntity.Item(id: id, data: "test".data(using: .utf8)!)
        }
        let domain = CacheEntity.Item(id: "test-id", items: domainItems, timestamp: Date())

        sut.update(with: domain, in: context)

        let dataEntities = sut.items.array as! [DataEntity]
        XCTAssertEqual(dataEntities[0].id, itemIDs[0])
        XCTAssertEqual(dataEntities[1].id, itemIDs[1])
    }

    // MARK: - Helpers

    private typealias SUT = CacheEntity

    private func makeSUT(file: StaticString = #file, line: UInt = #line) throws -> (SUT, NSManagedObjectContext) {
        let context = try makeContext()
        let sut = SUT(context: context)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, context)
    }

    private func makeContext(file: StaticString = #file, line: UInt = #line) throws -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.with(name: "CacheStore", in: Bundle(for: SUT.self))!
        let persistentStoreContainer = try! NSPersistentContainer.load(
            name: "CacheEntity",
            model: managedObjectModel,
            url: storeURL()
        )
        return persistentStoreContainer.viewContext
    }

    private func storeURL() -> URL {
        URL(fileURLWithPath: "/dev/null")
    }

    private func makeDataEntity(
        context: NSManagedObjectContext,
        data: Data,
        cache: CacheEntity,
        file: StaticString = #file,
        line: UInt = #line
    ) -> DataEntity {
        let entity = DataEntity(context: context)
        entity.id = UUID()
        entity.data = data
        entity.cache = cache
        trackForMemoryLeaks(entity, file: file, line: line)
        return entity
    }
}
