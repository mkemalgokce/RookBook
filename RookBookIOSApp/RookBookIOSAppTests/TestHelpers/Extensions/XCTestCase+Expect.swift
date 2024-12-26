// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import XCTest

extension XCTestCase {
    func expectPublisher<T: Publisher>(
        _ publisher: T,
        toCompleteWith expectedResult: Result<T.Output, T.Failure>,
        when action: (() -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Output: Equatable, T.Failure: Error {
        let expectation = expectation(description: "Wait for publisher completion")

        var receivedResult: Result<T.Output, T.Failure>?

        let cancellable = publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(failure):
                        receivedResult = .failure(failure)
                    default: break
                    }

                    expectation.fulfill()
                },
                receiveValue: { value in
                    if case .success = expectedResult {
                        receivedResult = .success(value)
                    }
                }
            )

        action?()

        wait(for: [expectation], timeout: 1.0)
        switch (receivedResult, expectedResult) {
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        case let (.success(receivedValue), .success(expectedValue)):
            XCTAssertEqual(receivedValue, expectedValue, file: file, line: line)
        default:
            XCTFail(
                "Expected \(expectedResult), got \(String(describing: receivedResult)) instead",
                file: file,
                line: line
            )
        }

        cancellable.cancel()
    }

    func expectPublisher<T: Publisher>(
        _ publisher: T,
        toCompleteWith expectedResult: Result<T.Output, T.Failure>,
        when action: (() -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Output == Void, T.Failure: Error {
        let expectation = expectation(description: "Wait for publisher completion")

        var receivedResult: Result<T.Output, T.Failure>?

        let cancellable = publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(failure):
                        receivedResult = .failure(failure)
                    default: break
                    }
                    expectation.fulfill()
                },
                receiveValue: { value in
                    if case .success = expectedResult {
                        receivedResult = .success(value)
                    }
                }
            )

        action?()

        wait(for: [expectation], timeout: 1.0)

        switch (receivedResult, expectedResult) {
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        case (.success, .success):
            break
        default:
            XCTFail(
                "Expected \(expectedResult), got \(String(describing: receivedResult)) instead",
                file: file,
                line: line
            )
        }

        cancellable.cancel()
    }
}
