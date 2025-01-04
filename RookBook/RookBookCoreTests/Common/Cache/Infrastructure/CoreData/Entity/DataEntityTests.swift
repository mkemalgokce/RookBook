// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import CoreData
import XCTest

final class DataEntityTests: XCTestCase {
    func test_toDomain_withValidData_mapsCorrectly() throws {
        let (sut, cache, _) = try makeSUT()
        let id = UUID()
        let data = "test-data".data(using: .utf8)!

        sut.id = id
        sut.data = data
        sut.cache = cache

        let domain = sut.toDomain()

        XCTAssertEqual(domain.id, id)
        XCTAssertEqual(domain.data, data)
    }

    func test_update_updatesAllProperties() throws {
        let (sut, _, context) = try makeSUT()
        let id = UUID()
        let data = "test-data".data(using: .utf8)!
        let domain = DataEntity.Item(id: id, data: data)

        sut.update(with: domain, in: context)

        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.data, data)
    }

    func test_domainItem_canDecodeData() throws {
        struct TestModel: Codable, Equatable {
            let message: String
        }

        let testModel = TestModel(message: "Hello")
        let data = try JSONEncoder().encode(testModel)
        let domainItem = DataEntity.Item(data: data)

        let decoded = try domainItem.toDomain(decodingType: TestModel.self)

        XCTAssertEqual(decoded, testModel)
    }

    func test_domainItem_throwsErrorOnInvalidData() throws {
        struct TestModel: Codable {}

        let invalidData = "invalid json".data(using: .utf8)!
        let domainItem = DataEntity.Item(data: invalidData)

        XCTAssertThrowsError(try domainItem.toDomain(decodingType: TestModel.self)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func test_domainItem_generatesUniqueIDByDefault() {
        let data = Data()

        let item1 = DataEntity.Item(data: data)
        let item2 = DataEntity.Item(data: data)

        XCTAssertNotEqual(item1.id, item2.id)
    }

    // MARK: - Helpers

    private typealias SUT = DataEntity

    private func makeSUT(file: StaticString = #file, line: UInt = #line) throws -> (
        SUT,
        CacheEntity,
        NSManagedObjectContext
    ) {
        let context = try makeContext()
        let cache = CacheEntity(context: context)
        let sut = SUT(context: context)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(cache, file: file, line: line)

        return (sut, cache, context)
    }

    private func makeContext(file: StaticString = #file, line: UInt = #line) throws -> NSManagedObjectContext {
        guard let managedObjectModel = NSManagedObjectModel.with(name: "CacheStore", in: Bundle(for: SUT.self)) else {
            XCTFail("Failed to load managed object model")
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        let persistentStoreContainer = try NSPersistentContainer.load(
            name: "CacheEntity",
            model: managedObjectModel,
            url: storeURL()
        )
        return persistentStoreContainer.viewContext
    }

    private func storeURL() -> URL {
        URL(fileURLWithPath: "/dev/null")
    }
}
