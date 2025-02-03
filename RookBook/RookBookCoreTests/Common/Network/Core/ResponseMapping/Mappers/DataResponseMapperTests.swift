// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class DataResponseMapperTests: XCTestCase {
    func test_map_deliversDataOnValidDataAndValidStatusCode() {
        let sut = makeSUT(validStatusCodes: 200..<300)
        let validData = anyData()
        let response = anyHTTPURLResponse(statusCode: 200)

        expect(sut, toCompleteWith: .success(validData), when: (validData, response))
    }

    func test_map_throwsInvalidResponseErrorOnInvalidStatusCode() {
        let sut = makeSUT(validStatusCodes: 200..<300)
        let validData = anyData()
        let response = anyHTTPURLResponse(statusCode: 404)

        expect(sut, toCompleteWith: .failure(DataResponseMapper.InvalidResponseError()), when: (validData, response))
    }

    func test_map_deliversDataOnValidDataWithCustomValidStatusCodes() {
        let sut = makeSUT(validStatusCodes: 200..<202)
        let validData = anyData()
        let response = anyHTTPURLResponse(statusCode: 201)

        expect(sut, toCompleteWith: .success(validData), when: (validData, response))
    }

    // MARK: - Helpers
    private func makeSUT(validStatusCodes: Range<Int> = 200..<300,
                         file: StaticString = #file,
                         line: UInt = #line) -> DataResponseMapper {
        let sut = DataResponseMapper(validStatusCodes: validStatusCodes)
        return sut
    }

    private func expect(
        _ sut: DataResponseMapper,
        toCompleteWith expectedResult: Result<Data, Error>,
        when dataAndResponse: (Data, HTTPURLResponse),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let (data, response) = dataAndResponse

        do {
            let receivedData = try sut.map(data: data, from: response)
            switch expectedResult {
            case let .success(expectedData):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case .failure:
                XCTFail("Expected failure, but got success with \(receivedData)", file: file, line: line)
            }
        } catch {
            switch expectedResult {
            case .success:
                XCTFail("Expected success, but got failure with \(error)", file: file, line: line)
            case let .failure(expectedError):
                XCTAssertTrue(error is DataResponseMapper.InvalidResponseError,
                              "Expected \(expectedError) to be \(DataResponseMapper.InvalidResponseError.self) but got \(error)",
                              file: file,
                              line: line)
            }
        }
    }
}
