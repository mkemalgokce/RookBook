// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class EmptyResponseMapperTests: XCTestCase {
    func test_init_withDefaultValues_ValidStatusCodeRangeShouldBe200To299() {
        let sut = makeSUT()
        XCTAssertEqual(sut.validStatusCodes, 200..<300)
    }

    func test_map_withValidStatusCode_ShouldNotThrowError() {
        let sut = makeSUT()
        let validResponse = anyHTTPURLResponse(statusCode: 200)
        let validData = anyData()

        XCTAssertNoThrow(try sut.map(data: validData, from: validResponse))
    }

    func test_map_withInvalidStatusCode_ShouldThrowError() {
        let sut = makeSUT()
        let invalidResponse = anyHTTPURLResponse(statusCode: 400)

        let invalidData = anyData()

        XCTAssertThrowsError(try sut.map(data: invalidData, from: invalidResponse)) { error in
            XCTAssertTrue(error is EmptyResponseMapper.InvalidResponseError)
        }
    }

    func test_map_withCustomValidStatusCodeRange_ShouldNotThrowError() {
        let sut = makeSUT(validStatusCodes: 300..<400)
        let validResponse = anyHTTPURLResponse(statusCode: 350)
        let validData = anyData()
        XCTAssertNoThrow(try sut.map(data: validData, from: validResponse))
    }

    func test_map_withCustomInvalidStatusCodeRange_ShouldThrowError() {
        let sut = makeSUT(validStatusCodes: 300..<400)
        let invalidResponse = anyHTTPURLResponse(statusCode: 200)

        let invalidData = anyData()

        XCTAssertThrowsError(try sut.map(data: invalidData, from: invalidResponse)) { error in
            XCTAssertTrue(error is EmptyResponseMapper.InvalidResponseError)
        }
    }

    // MARK: - Helpers
    private func makeSUT(validStatusCodes: Range<Int> = 200..<300) -> EmptyResponseMapper {
        EmptyResponseMapper(validStatusCodes: validStatusCodes)
    }
}
