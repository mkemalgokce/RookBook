// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

class PublisherFallbackTests: XCTestCase {
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    // MARK: - Tests
    func test_fallback_whenOriginalPublisherSucceeds_doesNotUseFallback() {
        let expectedValue = "original value"
        let originalPublisher = Just(expectedValue)
        let fallbackPublisher = { Just("fallback value").eraseToAnyPublisher() }
        let values = expectValues(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(values, [expectedValue])
    }

    func test_fallback_whenOriginalPublisherFails_usesFallback() {
        let expectedValue = "fallback value"
        let originalPublisher = Fail<String, Error>(error: NSError(domain: "test", code: 0))
        let fallbackPublisher = { Just(expectedValue).setFailureType(to: Error.self).eraseToAnyPublisher() }
        let values = expectValues(from: originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(values, [expectedValue])
    }

    func test_fallback_whenBothPublishersFail_propagatesLastError() {
        let originalError = NSError(domain: "original", code: 0)
        let fallbackError = NSError(domain: "fallback", code: 1)

        let originalPublisher = Fail<String, Error>(error: originalError)
        let fallbackPublisher = { Fail<String, Error>(error: fallbackError).eraseToAnyPublisher() }

        let error = expectError(originalPublisher.fallback(to: fallbackPublisher))

        XCTAssertEqual(error?.localizedDescription, fallbackError.localizedDescription)
    }

    func test_fallback_doesNotTriggerFallbackUntilOriginalFails() {
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

    // MARK: - Helpers
    private func expectValues<T: Publisher>(from publisher: T) -> [T.Output] where T.Output: Equatable {
        var values: [T.Output] = []
        let expectation = expectation(description: "Awaiting publisher")

        publisher
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { values.append($0) }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
        return values
    }

    private func expectError<T: Publisher>(_ publisher: T) -> Error? {
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

        wait(for: [expectation], timeout: 0.1)
        return capturedError
    }
}
