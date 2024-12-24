// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore
import XCTest

class URLSessionHTTPClientTests: XCTestCase {
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Override Methods
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
        URLProtocolStub.removeStub()
    }

    // MARK: - Tests
    func test_perform_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        let sut = makeSUT()
        let request = URLRequest(url: url)

        sut.perform(request)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { _, _ in })
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }

    func test_perform_failsOnRequestError() {
        let requestError = anyNSError()
        let exp = expectation(description: "Wait for completion")

        let sut = makeSUT()
        let request = URLRequest(url: anyURL())

        URLProtocolStub.stub(data: nil, response: nil, error: requestError)

        sut.perform(request)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTAssertEqual((error as NSError).code, requestError.code)
                    exp.fulfill()
                }
            }, receiveValue: { _, _ in
                XCTFail("Expected failure, got a value instead")
            })
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }

    func test_perform_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        let exp = expectation(description: "Wait for completion")

        let sut = makeSUT()
        let request = URLRequest(url: anyURL())

        URLProtocolStub.stub(data: data, response: response, error: nil)

        sut.perform(request)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure instead")
                }
            }, receiveValue: { receivedData, receivedResponse in
                XCTAssertEqual(receivedData, data)
                XCTAssertEqual(receivedResponse.url, response.url)
                XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
                exp.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }

    func test_perform_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        let exp = expectation(description: "Wait for completion")

        let sut = makeSUT()
        let request = URLRequest(url: anyURL())

        URLProtocolStub.stub(data: nil, response: response, error: nil)

        sut.perform(request)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure instead")
                }
            }, receiveValue: { receivedData, receivedResponse in
                XCTAssertEqual(receivedData, Data())
                XCTAssertEqual(receivedResponse.url, response.url)
                XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
                exp.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }

    func test_perform_deliversBadServerResponseErrorForNonHTTPResponse() {
        let url = anyURL()
        let exp = expectation(description: "Wait for badServerResponse error")
        let sut = makeSUT()
        let request = URLRequest(url: url)

        URLProtocolStub.stub(data: anyData(), response: nonHTTPURLResponse(), error: nil)

        sut.perform(request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected failure, but got finished")
                case let .failure(error):
                    guard let urlError = error as? URLError else {
                        return XCTFail("Expected URLError, but got \(error)")
                    }
                    XCTAssertEqual(urlError.code, .badServerResponse)
                    exp.fulfill()
                }
            }, receiveValue: { _, _ in
                XCTFail("Expected no values, but got a value")
            })
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
