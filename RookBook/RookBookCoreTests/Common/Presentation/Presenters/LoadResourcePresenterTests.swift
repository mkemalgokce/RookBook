// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import Combine
import XCTest

class LoadResourcePresenterTests: XCTestCase {
    func test_init_doesNotLoadResource() {
        let (_, loader, _) = makeSUT()

        XCTAssertTrue(loader.loadCallCount == 0)
    }

    func test_load_startsLoading() {
        let (sut, loader, views) = makeSUT()

        sut.load()

        XCTAssertEqual(views.loadingView.messages, [ResourceLoadingViewModel(isLoading: true)])
        XCTAssertTrue(loader.loadCallCount == 1)
    }

    func test_requestImage_callsLoader() {
        let (sut, loader, _) = makeSUT()

        sut.requestImage()
        XCTAssertTrue(loader.loadCallCount == 1)
    }

    func test_loadSuccess_stopsLoadingAndDeliversMappedResource() {
        let resource = "any resource"
        let mappedResource = "mapped resource"
        let (sut, loader, views) = makeSUT { _ in mappedResource }

        sut.load()
        loader.complete(with: resource)

        XCTAssertEqual(views.loadingView.messages, [
            ResourceLoadingViewModel(isLoading: true),
            ResourceLoadingViewModel(isLoading: false)
        ])
        XCTAssertEqual(views.resourceView.messages, [mappedResource])
    }

    func test_loadSuccess_stopsLoadingAndDeliversGivenResource_whenHasNoMapper() {
        let resource = "any resource"
        let (sut, loader, views) = makeSUT()

        sut.load()
        loader.complete(with: resource)

        XCTAssertEqual(views.loadingView.messages, [
            ResourceLoadingViewModel(isLoading: true),
            ResourceLoadingViewModel(isLoading: false)
        ])
        XCTAssertEqual(views.resourceView.messages, [resource])
    }

    func test_loadFailure_stopsLoadingAndDeliversError() {
        let error = anyNSError()
        let (sut, loader, views) = makeSUT()

        sut.load()
        loader.complete(with: error)

        XCTAssertEqual(views.loadingView.messages, [
            ResourceLoadingViewModel(isLoading: true),
            ResourceLoadingViewModel(isLoading: false)
        ])
        XCTAssertEqual(views.errorView.messages, [.error(message: error.localizedDescription)])
    }

    func test_loadFailure_whenMapperThrows_deliversMappingError() {
        let (sut, loader, views) = makeSUT { _ in throw NSError(domain: "mapping error", code: 0) }

        sut.load()
        loader.complete(with: "any resource")

        XCTAssertEqual(views.errorView.messages, [.error(message: "Mapping Error")])
    }

    func test_cancelImageRequest_cancelsLoading() {
        let (sut, loader, _) = makeSUT()

        sut.load()
        sut.cancelImageRequest()

        XCTAssertTrue(loader.cancelCallCount == 1)
    }

    func test_deinitSUT_cancelsLoading() {
        var sut: LoadResourcePresenter? = makeSUT().sut
        weak var weakSUT = sut

        sut?.load()
        sut = nil

        XCTAssertNil(weakSUT)
    }

    // MARK: - Helpers

    private typealias SUT = LoadResourcePresenter<String, ResourceViewSpy>

    private func makeSUT(
        mapper: SUT.Mapper? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SUT, loader: LoaderSpy, (
        loadingView: LoadingViewSpy,
        resourceView: ResourceViewSpy,
        errorView: ErrorViewSpy
    )) {
        let loader = LoaderSpy()
        let loadingView = LoadingViewSpy()
        let resourceView = ResourceViewSpy()
        let errorView = ErrorViewSpy()
        let sut: SUT
        if let mapper {
            sut = LoadResourcePresenter(
                resourceView: resourceView,
                errorView: errorView,
                loadingView: loadingView,
                loader: loader.publisher,
                mapper: mapper
            )
        } else {
            sut = LoadResourcePresenter(
                resourceView: resourceView,
                errorView: errorView,
                loadingView: loadingView,
                loader: loader.publisher
            )
        }

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(loadingView, file: file, line: line)
        trackForMemoryLeaks(resourceView, file: file, line: line)
        trackForMemoryLeaks(errorView, file: file, line: line)

        return (sut, loader, (loadingView, resourceView, errorView))
    }

    private class LoaderSpy {
        private var passthroughPublisher = PassthroughSubject<String, Error>()
        private(set) var loadCallCount = 0
        private(set) var cancelCallCount = 0
        private var cancellable: AnyCancellable?

        func complete(with resource: String) {
            passthroughPublisher.send(resource)
            passthroughPublisher.send(completion: .finished)
        }

        func complete(with error: Error) {
            passthroughPublisher.send(completion: .failure(error))
        }

        func publisher() -> AnyPublisher<String, Error> {
            loadCallCount += 1
            return passthroughPublisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelCallCount += 1
            }).eraseToAnyPublisher()
        }
    }

    private class ResourceViewSpy: ResourceView {
        typealias ViewModel = String

        private(set) var messages: [String] = []

        func display(_ viewModel: String) {
            messages.append(viewModel)
        }
    }

    private class LoadingViewSpy: ResourceLoadingView {
        private(set) var messages: [ResourceLoadingViewModel] = []

        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.append(viewModel)
        }
    }

    private class ErrorViewSpy: ResourceErrorView {
        private(set) var messages: [ResourceErrorViewModel] = []

        func display(_ viewModel: ResourceErrorViewModel) {
            messages.append(viewModel)
        }
    }
}
