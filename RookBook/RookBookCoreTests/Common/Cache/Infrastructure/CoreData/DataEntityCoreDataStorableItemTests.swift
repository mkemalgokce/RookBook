// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import CoreData
import XCTest

final class DataEntityCoreDataStorableItemTests: XCTestCase {
    func test_update_updatesProperties() throws {
        let (sut, context) = try makeSUT()
        let expectedID = anyURL()
        let expectedData = "Sample data".data(using: .utf8)!
        let expectedTimestamp = Date()
        let local = LocalData(id: expectedID, data: expectedData, cacheTimestamp: expectedTimestamp)

        sut.update(with: local, in: context)

        XCTAssertEqual(sut.id, expectedID, "Expected the id to be updated")
        XCTAssertEqual(sut.data, expectedData, "Expected the data to be updated")
        XCTAssertEqual(sut.cacheTimestamp, expectedTimestamp, "Expected the cacheTimestamp to be updated")
    }

    func test_toLocal_returnsLocalDataWithSameProperties() throws {
        let (sut, context) = try makeSUT()
        let expectedID = anyURL()
        let expectedData = "Another sample".data(using: .utf8)!
        let expectedTimestamp = Date()

        sut.id = expectedID
        sut.data = expectedData
        sut.cacheTimestamp = expectedTimestamp

        let local = sut.toLocal()

        XCTAssertEqual(local.id, expectedID, "Expected the id to match")
        XCTAssertEqual(local.data, expectedData, "Expected the data to match")
        XCTAssertEqual(local.cacheTimestamp, expectedTimestamp, "Expected the cacheTimestamp to match")
    }

    // MARK: - Helpers
    private func makeSUT() throws -> (sut: DataEntity, context: NSManagedObjectContext) {
        let context = makeContext()
        let sut = try XCTUnwrap(DataEntity(context: context))
        return (sut, context)
    }

    private func makeContext() -> NSManagedObjectContext {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let managedObjectModel = NSManagedObjectModel.with(name: "DataEntity", in: Bundle(for: DataEntity.self))!
        let container = try! NSPersistentContainer.load(name: "DataEntity", model: managedObjectModel, url: storeURL)
        let context = container.newBackgroundContext()
        return context
    }
}
