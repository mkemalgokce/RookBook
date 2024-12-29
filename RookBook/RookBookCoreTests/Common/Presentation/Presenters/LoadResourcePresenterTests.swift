// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

class LoadResourcePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToViews() {
        let (_, views) = makeSUT()

        XCTAssertTrue(views.errorView.messages.isEmpty)
        XCTAssertTrue(views.loadingView.messages.isEmpty)
        XCTAssertTrue(views.resourceView.messages.isEmpty)
    }

    func test_load_showsLoadingIndicatorBeforeLoadingResource() {
        let (sut, views) = makeSUT()
        let publisher = PassthroughSubject<String, Error>()

        sut.load(on: views.resourceView) { publisher.eraseToAnyPublisher() }

        XCTAssertEqual(views.loadingView.messages, [.init(isLoading: true)])
    }

    func test_load_hidesLoadingIndicatorOnLoadCompletion() {
        let (sut, views) = makeSUT()
        let publisher = PassthroughSubject<String, Error>()

        sut.load(on: views.resourceView) { publisher.eraseToAnyPublisher() }
        publisher.send("any")
        publisher.send(completion: .finished)

        XCTAssertEqual(views.loadingView.messages, [
            .init(isLoading: true),
            .init(isLoading: false)
        ])
    }

    func test_load_hidesLoadingIndicatorOnLoadError() {
        let (sut, views) = makeSUT()
        let publisher = PassthroughSubject<String, Error>()

        sut.load(on: views.resourceView) { publisher.eraseToAnyPublisher() }
        publisher.send(completion: .failure(anyNSError()))

        XCTAssertEqual(views.loadingView.messages, [
            .init(isLoading: true),
            .init(isLoading: false)
        ])
    }

    func test_load_deliversErrorOnLoadError() {
        let (sut, views) = makeSUT()
        let publisher = PassthroughSubject<String, Error>()
        let error = anyNSError()

        sut.load(on: views.resourceView, loader: { publisher.eraseToAnyPublisher() }, mapper: { $0 })
        publisher.send(completion: .failure(error))

        XCTAssertEqual(views.errorView.messages, [
            .error(message: error.localizedDescription)
        ])
    }

    func test_load_deliversMappedResourceOnLoadSuccess() {
        let (sut, views) = makeSUT()
        let publisher = PassthroughSubject<String, Error>()

        sut.load(on: views.resourceView, loader: { publisher.eraseToAnyPublisher() }, mapper: { $0 })
        publisher.send("any value")
        publisher.send(completion: .finished)

        XCTAssertEqual(views.resourceView.messages, ["any value"])
    }

    func test_load_deliversMappingErrorOnMapperError() {
        let (sut, views) = makeSUT()
        let publisher = PassthroughSubject<String, Error>()
        let error = anyNSError()
        let mapper: (String) throws -> String = { _ in throw error }

        sut.load(on: views.resourceView, loader: { publisher.eraseToAnyPublisher() }, mapper: mapper)
        publisher.send("any")

        XCTAssertEqual(views.errorView.messages, [.error(message: "Mapping Error")])
        XCTAssertTrue(views.resourceView.messages.isEmpty)
    }

    func test_deinitSUT_cancelsLoading() {
        var sut: LoadResourcePresenter? = makeSUT().sut
        weak var weakSUT = sut

        sut?.load(on: ResourceViewSpy()) { Just("any").setFailureType(to: Error.self).eraseToAnyPublisher() }
        sut = nil

        XCTAssertNil(weakSUT)
    }

    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: LoadResourcePresenter,
        views: (resourceView: ResourceViewSpy, errorView: ErrorViewSpy, loadingView: LoadingViewSpy)
    ) {
        let errorView = ErrorViewSpy()
        let loadingView = LoadingViewSpy()
        let resourceView = ResourceViewSpy()
        let sut = LoadResourcePresenter(
            errorView: errorView,
            loadingView: loadingView
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(errorView, file: file, line: line)
        trackForMemoryLeaks(loadingView, file: file, line: line)
        trackForMemoryLeaks(resourceView, file: file, line: line)
        return (sut, (resourceView, errorView, loadingView))
    }
}
