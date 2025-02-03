// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
@testable import RookBookIOSApp
import Combine
import RookBookCore
import XCTest

final class BookUIIntegrationTests: XCTestCase {
    func test_bookView_hasTitle() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.title, bookListTitle)
    }

    func test_bookView_showsEmptyView_whenDoesNotHaveBook() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertFalse(sut.isTableViewEmpty, "Table should not be empty when the view appears")

        loader.completeLoad(at: 0)
        XCTAssertTrue(sut.isTableViewEmpty, "Table should display empty state when no books are loaded")

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isTableViewEmpty, "Table should remain empty during reloading with no books")

        loader.completeLoad(with: [makeBook()], at: 1)
        XCTAssertFalse(sut.isTableViewEmpty, "Table should display content when books are loaded")

        sut.simulateUserInitiatedReload()

        loader.completeLoad(at: 2)
        XCTAssertTrue(
            sut.isTableViewEmpty,
            "Table should display empty state again when no books are loaded after reload"
        )
    }

    func test_loadActions_requestsFromLoader() {
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadRequests.count, 0, "Expected no loading requests before view is loaded")

        sut.simulateAppearance()
        XCTAssertEqual(loader.loadRequests.count, 1, "Expected a loading request once the view is loaded")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(
            loader.loadRequests.count,
            2,
            "Expected another loading request once the user initiates a reload"
        )

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(
            loader.loadRequests.count,
            3,
            "Expected another loading request once the user initiates a reload"
        )
    }

    func test_loadingBook_indicatorVisibility() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator to be visible while loading")

        loader.completeLoad(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator to be visible after loading")

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator to be visible while loading")

        loader.completeLoadWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator to be visible after loading")
    }

    func test_loadCompletion_rendersSuccessfullyLoadedBook() {
        let book0 = makeBook(description: "another description")
        let book1 = makeBook(title: "another title")
        let book2 = makeBook(description: "different description")
        let book3 = makeBook(title: "different title")
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        assertThat(sut, isRendering: [])

        loader.completeLoad(with: [book0], at: 0)
        assertThat(sut, isRendering: [book0])

        sut.simulateUserInitiatedReload()
        loader.completeLoad(with: [book0, book1, book2, book3], at: 1)
        assertThat(sut, isRendering: [book0, book1, book2, book3])
    }

    func test_loadBookCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let book0 = makeBook()
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoad(with: [book0], at: 0)
        assertThat(sut, isRendering: [book0])

        sut.simulateUserInitiatedReload()
        loader.completeLoadWithError(at: 1)
        assertThat(sut, isRendering: [book0])
    }

    func test_bookLoads_imageURLWhenVisible() {
        let book0 = makeBook(image: anyURL(withKey: "any"))
        let book1 = makeBook(image: anyURL(withKey: "another"))

        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoad(with: [book0, book1], at: 0)

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateCellVisible(at: 0)
        XCTAssertEqual(
            loader.loadedImageURLs,
            [book0.coverImage],
            "Expected first coverImage URL request once first view becomes visible"
        )

        sut.simulateCellVisible(at: 1)
        XCTAssertEqual(
            loader.loadedImageURLs,
            [book0.coverImage, book1.coverImage],
            "Expected second image URL request once second view also becomes visible"
        )
    }

    func test_bookCancelsImageLoading_whenNotVisibleAnymore() {
        let book0 = makeBook()
        let book1 = makeBook(image: anyURL(withKey: "another"))

        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoad(with: [book0, book1], at: 0)

        XCTAssertEqual(
            loader.cancelledImageURLs,
            [],
            "Expected no cancelled image URL requests until book is not visible"
        )

        sut.simulateCellNotVisible(at: 0)
        XCTAssertEqual(
            loader.cancelledImageURLs,
            [book0.coverImage],
            "Expected once cancelled coverImage URL request once first view is not visible anymore"
        )

        sut.simulateCellNotVisible(at: 1)
        XCTAssertEqual(
            loader.cancelledImageURLs,
            [book0.coverImage, book1.coverImage],
            "Expected two cancelled coverImage URL request once second view is also not visible anymore"
        )
    }

    func test_bookLoadingIndicator_isVisible_whileLoadingImage() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let book0 = makeBook(image: anyURL(withKey: "a1"))
        let book1 = makeBook(image: anyURL(withKey: "a2"))
        loader.completeLoad(with: [book0, book1], at: 0)

        let view0: BookCell? = sut.simulateCellVisible(at: 0)
        let view1: BookCell? = sut.simulateCellVisible(at: 1)

        XCTAssertEqual(
            view0?.isImageLoading,
            true,
            "Expected no loading indicator to be visible for the first cell while loading the image"
        )
        XCTAssertEqual(
            view1?.isImageLoading,
            true,
            "Expected loading indicator to be visible for the second cell while loading the image"
        )

        loader.completeLoadImage(at: 0)

        XCTAssertEqual(
            view0?.isImageLoading,
            false,
            "Expected loading indicator to be visible for the first cell once the image is loaded"
        )
        XCTAssertEqual(
            view1?.isImageLoading,
            true,
            "Expected loading indicator to be visible for the second cell while loading the image"
        )
    }

    func test_bookRendersImage_loadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let book0 = makeBook(image: anyURL(withKey: "a1"))
        let book1 = makeBook(image: anyURL(withKey: "a2"))

        loader.completeLoad(with: [book0, book1], at: 0)

        let view0: BookCell? = sut.simulateCellVisible(at: 0)
        let view1: BookCell? = sut.simulateCellVisible(at: 1)

        XCTAssertEqual(
            view0?.renderedImage,
            .emptyImageData,
            "Expected no book for first view while loading first book"
        )
        XCTAssertEqual(
            view1?.renderedImage,
            .emptyImageData,
            "Expected no book for second view while loading second book"
        )

        let imageData0 = UIImage.make(withColor: .red).pngData()
        loader.completeLoadImage(with: imageData0, at: 0)

        XCTAssertEqual(
            view0?.renderedImage,
            imageData0,
            "Expected image for first view once first image loading completes successfully"
        )
        XCTAssertEqual(
            view1?.renderedImage,
            .emptyImageData,
            "Expected no image for second view while loading second image"
        )

        let imageData1 = UIImage.make(withColor: .green).pngData()
        loader.completeLoadImage(with: imageData1, at: 1)

        XCTAssertEqual(
            view0?.renderedImage,
            imageData0,
            "Expected image for first view once first image loading completes successfully"
        )
        XCTAssertEqual(
            view1?.renderedImage,
            imageData1,
            "Expected for second view once second image loading completes successfully"
        )
    }

    func test_bookPreloadsImageURL_whenNearVisible() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let book0 = makeBook(image: anyURL(withKey: "a1"))
        let book1 = makeBook(image: anyURL(withKey: "a2"))

        loader.completeLoad(with: [book0, book1], at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [])

        sut.simulateCellNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [book0.coverImage])

        sut.simulateCellNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [book0.coverImage, book1.coverImage])
    }

    func test_bookCancelsImageURL_whenNotNearVisibleAnymore() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let book0 = makeBook(image: anyURL(withKey: "a1"))
        let book1 = makeBook(image: anyURL(withKey: "a2"))

        loader.completeLoad(with: [book0, book1], at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [])

        sut.simulateCellNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [book0.coverImage])

        sut.simulateCellNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [book0.coverImage, book1.coverImage])
    }

    func test_bookView_doesNotRenderLoadedBook_whenNotVisibleAnymore() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let book0 = makeBook(image: anyURL(withKey: "a1"))

        loader.completeLoad(with: [book0], at: 0)
        let view: BookCell? = sut.simulateCellNotVisible(at: 0)
        loader.completeLoadImage(with: anyImageData(), at: 0)

        XCTAssertEqual(view?.renderedImage, .emptyImageData, "Expected no rendered book when cell is not visible")
    }

    func test_loadBookCompletion_dispatchesFromBackgroundToMainQueue() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let exp = expectation(description: "Book loading completion")
        DispatchQueue.global().async {
            loader.completeLoad(at: 0)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainQueue() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()

        let book0 = makeBook(image: anyURL(withKey: "a1"))
        loader.completeLoad(with: [book0], at: 0)
        _ = sut.simulateCellVisible(at: 0)

        let exp = expectation(description: "Image loading completion")
        DispatchQueue.global().async {
            loader.completeLoadImage(at: 0)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers
    private func makeSUT(onSelection: @escaping (Book) -> Void = { _ in },
                         file: StaticString = #file,
                         line: UInt = #line) -> (sut: BookViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = BookUIComposer.composed(
            loadBooks: loader.loadPublisher,
            loadImage: loader.loadImagePublisher,
            onSelection: onSelection
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }

    private func anyImageData() -> Data {
        let image = UIImage.make(withColor: .red)
        return image.pngData()!
    }
}

extension BookViewController {
    func simulateUserInitiatedReload() {
        rootView.refreshControl.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        isLoading
    }

    var isTableViewEmpty: Bool {
        rootView.isTableViewEmpty
    }
}
