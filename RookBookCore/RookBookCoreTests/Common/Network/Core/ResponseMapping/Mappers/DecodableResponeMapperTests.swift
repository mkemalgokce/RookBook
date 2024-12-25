// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class DecodableResourceResponseMapperTests: XCTestCase {
    func test_map_deliversResourceOnValidDataAndValidStatusCode() {
        let sut = makeSUT(validStatusCodes: 200..<201)
        let validData = makeValidData()
        let response = anyHTTPURLResponse(statusCode: 200)

        expect(sut, toCompleteWith: .success(TestResource(id: 1, name: "Test Name")), when: (validData, response))
    }

    func test_map_throwsInvalidDataErrorOnInvalidData() {
        let sut = makeSUT(validStatusCodes: 200..<201)
        let invalidData = makeInvalidData()
        let response = anyHTTPURLResponse(statusCode: 200)

        expect(
            sut,
            toCompleteWith: .failure(SUT.Error.invalidData),
            when: (invalidData, response)
        )
    }

    func test_map_throwsInvalidDataErrorOnInvalidStatusCode() {
        let sut = makeSUT(validStatusCodes: 200..<201)
        let validData = makeValidData()
        let response = anyHTTPURLResponse(statusCode: 404)

        expect(
            sut,
            toCompleteWith: .failure(SUT.Error.invalidData),
            when: (validData, response)
        )
    }

    func test_map_deliversResourceOnValidDataWithCustomValidStatusCodes() {
        let sut = makeSUT(validStatusCodes: 200..<202)
        let validData = makeValidData()
        let response = anyHTTPURLResponse(statusCode: 201)

        expect(sut, toCompleteWith: .success(TestResource(id: 1, name: "Test Name")), when: (validData, response))
    }

    // MARK: - Helpers
    private typealias SUT = DecodableResourceResponseMapper<TestResource>
    private struct TestResource: Codable, Equatable {
        let id: Int
        let name: String
    }

    private func makeSUT(validStatusCodes: Range<Int> = 200..<201, file: StaticString = #file,
                         line: UInt = #line) -> SUT {
        let sut = SUT(validStatusCodes: validStatusCodes)
        return sut
    }

    private func makeValidData() -> Data {
        try! JSONEncoder().encode(TestResource(id: 1, name: "Test Name"))
    }

    private func makeInvalidData() -> Data {
        anyData()
    }

    private func expect(
        _ sut: SUT,
        toCompleteWith expectedResult: Result<TestResource, Error>,
        when dataAndResponse: (Data, HTTPURLResponse),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let (data, response) = dataAndResponse

        do {
            let result = try sut.map(data: data, from: response)
            switch expectedResult {
            case let .success(expectedResource):
                XCTAssertEqual(result, expectedResource, file: file, line: line)
            case .failure:
                XCTFail("Expected failure, got success with \(result) instead", file: file, line: line)
            }
        } catch {
            switch expectedResult {
            case .success:
                XCTFail("Expected success, got failure with \(error) instead", file: file, line: line)
            case let .failure(expectedError):
                XCTAssertEqual(
                    error as? SUT.Error,
                    expectedError as? SUT.Error,
                    file: file,
                    line: line
                )
            }
        }
    }
}
