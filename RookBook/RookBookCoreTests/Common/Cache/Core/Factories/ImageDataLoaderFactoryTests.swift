// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

final class ImageDataLoaderFactoryTests: XCTestCase {
    // MARK: - Tests
    func test_makeLocalImageLoaderWithRemoteFallback_onSuccessfulLocalLoad_deliversLocalData() {
        let url = anyURL()
        let expectedData = Data("local image data".utf8)
        let localData = LocalData(id: url, data: expectedData)
        let (sut, client, store) = makeSUT()

        store.loadItemResult = .success(localData)

        expectPublisher(
            sut.makeLocalImageLoaderWithRemoteFallback(url: url),
            toCompleteWith: .success(expectedData),
            when: { /* no remote call needed */ }
        )

        XCTAssertTrue(client.requests.isEmpty, "Expected no remote requests when local load succeeds")
    }

    func test_makeLocalImageLoaderWithRemoteFallback_onLocalFailure_deliversRemoteData_andCachesData() {
        let url = anyURL()
        let expectedData = Data("remote image data".utf8)
        let (sut, client, store) = makeSUT()
        store.loadItemResult = .failure(anyNSError())

        expectPublisher(
            sut.makeLocalImageLoaderWithRemoteFallback(url: url),
            toCompleteWith: .success(expectedData),
            when: {
                client.complete(with: expectedData, and: anyHTTPURLResponse())
            }
        )

        switch store.receivedMessages.last {
        case let .save(item: result):
            XCTAssertEqual(result.id, url)
            XCTAssertEqual(result.data, expectedData)
        default:
            XCTFail("Expected to cache remote data")
        }
    }

    func test_makeLocalImageLoaderWithRemoteFallback_onLocalFailureAndRemoteFailure_deliversError() {
        let url = anyURL()
        let (sut, client, store) = makeSUT()

        store.loadItemResult = .failure(anyNSError())
        let remoteError = anyNSError()

        expectPublisher(
            sut.makeLocalImageLoaderWithRemoteFallback(url: url),
            toCompleteWith: .failure(remoteError),
            when: {
                client.complete(withError: remoteError)
            }
        )
    }

    // MARK: - Helpers
    private typealias ImageStoreSpy = StoreSpy<LocalData, URL>
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ImageDataLoaderFactory, client: HTTPClientSpy, store: ImageStoreSpy) {
        let client = HTTPClientSpy()
        let store = ImageStoreSpy()
        let scheduler = AnyDispatchQueueScheduler.immediateOnMainQueue
        let sut = ImageDataLoaderFactory(
            client: client,
            imageStore: AnyStorable(store),
            scheduler: scheduler
        )
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client, store)
    }

    // Used to store Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
}
