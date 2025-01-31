// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class DictionaryRequestBuilderTests: XCTestCase {
    func test_build_withValidDictionary_shouldSetCorrectHttpBody() {
        let (sut, dummyDict) = makeSUT()
        let url = URL(string: "https://example.com")!
        let expectedBody = try! JSONSerialization.data(withJSONObject: dummyDict.toStringDictionary())

        let request = sut.build(on: url, from: dummyDict, with: .post)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, expectedBody)
    }

    func test_build_withHeaders_shouldSetCorrectHeaders() {
        let (sut, dummyDict) = makeSUT()
        let url = URL(string: "https://example.com")!
        let headers = ["Authorization": "Bearer token"]

        let request = sut.build(on: url, from: dummyDict, with: .get, headers: headers)

        XCTAssertEqual(request.allHTTPHeaderFields, headers)
    }

    func test_build_withDifferentMethods_shouldSetCorrectHttpMethod() {
        let (sut, dummyDict) = makeSUT()
        let url = URL(string: "https://example.com")!

        let postRequest = sut.build(on: url, from: dummyDict, with: .post)
        let getRequest = sut.build(on: url, from: dummyDict, with: .get)

        XCTAssertEqual(postRequest.httpMethod, "POST")
        XCTAssertEqual(getRequest.httpMethod, "GET")
    }

    func test_build_withEmptyHeaders_shouldHaveNoHeaders() {
        let (sut, dummyDict) = makeSUT()
        let url = URL(string: "https://example.com")!

        let request = sut.build(on: url, from: dummyDict, with: .delete, headers: [:])

        XCTAssertEqual(request.allHTTPHeaderFields, [:])
    }

    func test_build_withEmptyDictionary_shouldSetEmptyHttpBody() {
        let (sut, emptyDict) = makeSUT(empty: true)
        let url = URL(string: "https://example.com")!

        let request = sut.build(on: url, from: emptyDict, with: .post)

        XCTAssertEqual(request.httpBody, try? JSONSerialization.data(withJSONObject: [:]))
    }

    // MARK: - Helpers
    private func makeSUT(empty: Bool = false)
        -> (sut: DictionaryRequestBuilder.Type, dict: MockStringDictionaryConvertible) {
        let dummyDict = MockStringDictionaryConvertible(dictionary: empty ? [:] : ["key": "value"])
        return (DictionaryRequestBuilder.self, dummyDict)
    }

    // MARK: - Mock
    private struct MockStringDictionaryConvertible: StringDictionaryConvertible {
        let dictionary: [String: Any]
        func toStringDictionary() -> [String: Any?] {
            dictionary
        }
    }
}
