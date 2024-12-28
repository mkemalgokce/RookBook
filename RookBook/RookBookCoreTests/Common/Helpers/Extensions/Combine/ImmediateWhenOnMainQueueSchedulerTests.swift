// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

class SchedulerTests: XCTestCase {
    // MARK: - Publisher Extension Tests
    func test_dispatchOnMainThread_whenOnMainThread_executesImmediately() {
        let exp = expectation(description: "Should execute immediately")
        var executedValue: Int?
        let publisher = Just(1).dispatchOnMainThread()

        DispatchQueue.main.async {
            publisher
                .sink { value in
                    executedValue = value
                    exp.fulfill()
                }
                .store(in: &self.cancellables)
        }

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(executedValue, 1)
    }

    func test_dispatchOnMainThread_whenOnBackgroundThread_executesOnMainThread() {
        let exp = expectation(description: "Should execute on main thread")
        var isOnMainThread = false
        let publisher = Just(1).dispatchOnMainThread()

        DispatchQueue.global().async {
            publisher
                .sink { _ in
                    isOnMainThread = Thread.isMainThread
                    exp.fulfill()
                }
                .store(in: &self.cancellables)
        }

        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(isOnMainThread)
    }

    // MARK: - ImmediateWhenOnMainQueueScheduler Tests
    func test_immediateWhenOnMainQueueScheduler_properties() {
        let scheduler = DispatchQueue.immediateWhenOnMainQueueScheduler

        XCTAssertNotNil(scheduler.now)
        XCTAssertNotNil(scheduler.minimumTolerance)
    }

    func test_immediateWhenOnMainQueueScheduler_schedulingMethods() {
        let scheduler = DispatchQueue.immediateWhenOnMainQueueScheduler
        let exp1 = expectation(description: "Basic schedule")
        let exp2 = expectation(description: "Schedule after")
        var intervalCount = 0

        scheduler.schedule { exp1.fulfill() }

        scheduler.schedule(
            after: scheduler.now.advanced(by: 0.1),
            tolerance: scheduler.minimumTolerance,
            options: nil
        ) {
            exp2.fulfill()
        }

        let intervalExp = expectation(description: "Schedule interval")
        let cancellable = scheduler.schedule(
            after: scheduler.now,
            interval: .seconds(0.1),
            tolerance: scheduler.minimumTolerance,
            options: nil
        ) {
            intervalCount += 1
            if intervalCount == 1 {
                intervalExp.fulfill()
            }
        }

        wait(for: [exp1, exp2, intervalExp], timeout: 1.0)
        cancellable.cancel()
        XCTAssertGreaterThanOrEqual(intervalCount, 1)
    }

    func test_immediateWhenOnMainQueueScheduler_executesImmediatelyOnMainQueue() {
        let scheduler = DispatchQueue.immediateWhenOnMainQueueScheduler
        let exp = expectation(description: "Should execute on main queue")
        var isOnMainThread = false

        DispatchQueue.global().async {
            scheduler.schedule {
                isOnMainThread = Thread.isMainThread
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)

        XCTAssertTrue(isOnMainThread)
    }

    // MARK: - ImmediateWhenOnMainThreadScheduler Tests
    func test_immediateWhenOnMainThreadScheduler_properties() {
        let scheduler = DispatchQueue.immediateWhenOnMainThreadScheduler

        XCTAssertNotNil(scheduler.now)
        XCTAssertNotNil(scheduler.minimumTolerance)
    }

    func test_immediateWhenOnMainThreadScheduler_schedulingMethods() {
        let scheduler = DispatchQueue.immediateWhenOnMainThreadScheduler
        let exp1 = expectation(description: "Basic schedule")
        let exp2 = expectation(description: "Schedule after")
        var intervalCount = 0

        scheduler.schedule { exp1.fulfill() }

        scheduler.schedule(
            after: scheduler.now.advanced(by: 0.1),
            tolerance: scheduler.minimumTolerance,
            options: nil
        ) {
            exp2.fulfill()
        }

        let intervalExp = expectation(description: "Schedule interval")
        let cancellable = scheduler.schedule(
            after: scheduler.now,
            interval: .seconds(0.1),
            tolerance: scheduler.minimumTolerance,
            options: nil
        ) {
            intervalCount += 1
            if intervalCount == 1 {
                intervalExp.fulfill()
            }
        }

        wait(for: [exp1, exp2, intervalExp], timeout: 1.0)
        cancellable.cancel()
        XCTAssertGreaterThanOrEqual(intervalCount, 1)
    }

    // MARK: - AnyScheduler Tests
    func test_anyScheduler_properties() {
        let originalScheduler = DispatchQueue.main
        let anyScheduler = AnyScheduler(originalScheduler)

        XCTAssertNotNil(anyScheduler.now)
        XCTAssertNotNil(anyScheduler.minimumTolerance)
    }

    func test_anyScheduler_schedulingMethods() {
        let scheduler = AnyScheduler(DispatchQueue.main)
        let exp1 = expectation(description: "Basic schedule")
        let exp2 = expectation(description: "Schedule after")
        var intervalCount = 0

        scheduler.schedule { exp1.fulfill() }

        scheduler.schedule(
            after: scheduler.now.advanced(by: 0.1),
            tolerance: scheduler.minimumTolerance,
            options: nil
        ) {
            exp2.fulfill()
        }

        let intervalExp = expectation(description: "Schedule interval")
        let cancellable = scheduler.schedule(
            after: scheduler.now,
            interval: .seconds(0.1),
            tolerance: scheduler.minimumTolerance,
            options: nil
        ) {
            intervalCount += 1
            if intervalCount == 1 {
                intervalExp.fulfill()
            }
        }

        wait(for: [exp1, exp2, intervalExp], timeout: 1.0)
        cancellable.cancel()
        XCTAssertGreaterThanOrEqual(intervalCount, 1)
    }

    func test_anyDispatchQueueScheduler_staticProperties() {
        XCTAssertNotNil(AnyDispatchQueueScheduler.immediateOnMainQueue)
        XCTAssertNotNil(AnyDispatchQueueScheduler.immediateOnMainThread)
    }

    func test_anyScheduler_erasure() {
        let originalScheduler = DispatchQueue.main
        let erasedScheduler = originalScheduler.eraseToAnyScheduler()
        XCTAssertNotNil(erasedScheduler)
    }

    func test_immediateWhenOnMainQueueScheduler_shared() {
        let scheduler1 = DispatchQueue.immediateWhenOnMainQueueScheduler
        let scheduler2 = DispatchQueue.immediateWhenOnMainQueueScheduler
        XCTAssertTrue(type(of: scheduler1) == type(of: scheduler2))
    }

    // MARK: - Helper Properties
    private var cancellables = Set<AnyCancellable>()
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
}
