// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

final class PublisherFallbackTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    // MARK: - Closure Based Fallback Tests
    func test_fallbackWithClosure_whenOriginalPublisherSucceeds_doesNotUseFallback() {
        let expectedValue = "original value"
        let originalPublisher = Just(expectedValue)
        let fallbackPublisher = { Just("fallback value").eraseToAnyPublisher() }

        let values = expectValues(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(values, [expectedValue])
    }

    func test_fallbackWithClosure_whenOriginalPublisherFails_usesFallback() {
        let expectedValue = "fallback value"
        let originalPublisher = Fail<String, Error>(error: anyNSError())
        let fallbackPublisher = { Just(expectedValue).setFailureType(to: Error.self).eraseToAnyPublisher() }

        let values = expectValues(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(values, [expectedValue])
    }

    func test_fallbackWithClosure_whenBothPublishersFail_propagatesLastError() {
        let originalError = NSError(domain: "original", code: 0)
        let fallbackError = NSError(domain: "fallback", code: 1)
        let originalPublisher = Fail<String, Error>(error: originalError)
        let fallbackPublisher = { Fail<String, Error>(error: fallbackError).eraseToAnyPublisher() }

        let error = expectError(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(error as NSError?, fallbackError)
    }

    func test_fallbackWithClosure_doesNotTriggerFallbackUntilOriginalFails() {
        let expectation = expectation(description: "Should not call fallback")
        expectation.isInverted = true

        let originalPublisher = Just("original value")
        let fallbackPublisher = {
            expectation.fulfill()
            return Just("fallback value").eraseToAnyPublisher()
        }

        originalPublisher
            .fallback(to: fallbackPublisher)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    // MARK: - Publisher Based Fallback Tests
    func test_fallbackWithPublisher_whenOriginalPublisherSucceeds_doesNotUseFallback() {
        let expectedValue = "original value"
        let originalPublisher = Just(expectedValue)
        let fallbackPublisher = Just("fallback value").eraseToAnyPublisher()

        let values = expectValues(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(values, [expectedValue])
    }

    func test_fallbackWithPublisher_whenOriginalPublisherFails_usesFallback() {
        let expectedValue = "fallback value"
        let originalPublisher = Fail<String, Error>(error: anyNSError())
        let fallbackPublisher = Just(expectedValue).setFailureType(to: Error.self).eraseToAnyPublisher()

        let values = expectValues(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(values, [expectedValue])
    }

    func test_fallbackWithPublisher_whenBothPublishersFail_propagatesLastError() {
        let originalError = NSError(domain: "original", code: 0)
        let fallbackError = NSError(domain: "fallback", code: 1)
        let originalPublisher = Fail<String, Error>(error: originalError)
        let fallbackPublisher = Fail<String, Error>(error: fallbackError).eraseToAnyPublisher()

        let error = expectError(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(error as NSError?, fallbackError)
    }

    // MARK: - Helpers
    private func expectValues<T: Publisher>(
        from publisher: T,
        timeout: TimeInterval = 0.1
    ) -> [T.Output] where T.Output: Equatable {
        var values: [T.Output] = []
        let expectation = expectation(description: "Awaiting publisher")

        publisher
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { values.append($0) }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
        return values
    }

    private func expectError<T: Publisher>(
        from publisher: T,
        timeout: TimeInterval = 0.1
    ) -> Error? {
        var capturedError: Error?
        let expectation = expectation(description: "Awaiting publisher error")

        publisher
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        capturedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
        return capturedError
    }
}
