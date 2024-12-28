// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class OnboardingPresenterTests: XCTestCase {
    func test_onInit_doesNotDisplayAnyPage() {
        let (_, view) = makeSUT()

        XCTAssertNil(view.displayedPage)
    }

    func test_onNextPage_displaysNextPage() {
        let (sut, view) = makeSUT()

        sut.displayNextPage()
        XCTAssertEqual(view.displayedPage, 1)

        sut.displayNextPage()
        XCTAssertEqual(view.displayedPage, 2)
    }

    func test_onNextPage_afterLastPage_doesNotDisplayAnyPage() {
        let totalPages = 3
        let (sut, view) = makeSUT(totalPages: 3)

        for _ in 0..<totalPages + 5 {
            sut.displayNextPage()
        }

        XCTAssertEqual(view.displayedPage, totalPages - 1)
    }

    func test_onPreviousPage_displaysPreviousPage() {
        let (sut, view) = makeSUT()

        sut.displayNextPage()
        sut.displayNextPage()
        XCTAssertEqual(view.displayedPage, 2)

        sut.displayPreviousPage()
        XCTAssertEqual(view.displayedPage, 1)

        sut.displayPreviousPage()
        XCTAssertEqual(view.displayedPage, 0)
    }

    func test_onPreviousPage_atFirstPage_staysOnFirstPage() {
        let (sut, view) = makeSUT()

        sut.displayPreviousPage()
        XCTAssertNil(view.displayedPage)

        sut.displayNextPage()
        sut.displayPreviousPage()
        sut.displayPreviousPage()
        XCTAssertEqual(view.displayedPage, 0)
    }

    func test_onUpdatePage_displaysCorrectPage() {
        let (sut, view) = makeSUT()

        sut.updatePage(for: 1)
        XCTAssertEqual(view.displayedPage, 1)

        sut.updatePage(for: 2)
        XCTAssertEqual(view.displayedPage, 2)
    }

    func test_onUpdatePage_withInvalidIndex_displaysLastPage() {
        let totalPages = 3
        let (sut, view) = makeSUT(totalPages: totalPages)

        sut.updatePage(for: totalPages + 1)
        XCTAssertEqual(view.displayedPage, totalPages - 1)

        sut.updatePage(for: -1)
        XCTAssertEqual(view.displayedPage, 0)
    }

    func test_onCompletion_isCalledOnLastPage() {
        var completionCallCount = 0
        let (sut, _) = makeSUT(totalPages: 3) {
            completionCallCount += 1
        }

        sut.displayNextPage()
        XCTAssertEqual(completionCallCount, 0)

        sut.displayNextPage()
        XCTAssertEqual(completionCallCount, 0)

        sut.displayNextPage()
        XCTAssertEqual(completionCallCount, 1)

        sut.displayNextPage()
        XCTAssertEqual(completionCallCount, 2)
    }

    func test_makeTextConfiguration_returnsValidConfiguration() {
        let config = OnboardingPresenter.makeTextConfiguration()

        XCTAssertEqual(config.nextButtonTitle, OnboardingPresenter.nextButtonTitle)
        XCTAssertEqual(config.previousButtonTitle, OnboardingPresenter.previousButtonTitle)
        XCTAssertEqual(config.finishButtonTitle, OnboardingPresenter.finishButtonTitle)
        XCTAssertEqual(config.title, OnboardingPresenter.title)
    }

    // MARK: - OnboardingPageViewModel
    func test_onboardingPageViewModel_onInit() {
        let viewModel = OnboardingPageViewModel(
            title: "title",
            subtitle: "description",
            image: "image"
        )

        XCTAssertEqual(viewModel.title, "title")
        XCTAssertEqual(viewModel.subtitle, "description")
        XCTAssertEqual(viewModel.image, "image")
    }

    // MARK: - Helpers
    private func makeSUT(
        totalPages: Int = 3,
        onCompletion: @escaping () -> Void = {},
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: OnboardingPresenter, view: MockOnboardingView) {
        let view = MockOnboardingView()
        let sut = OnboardingPresenter(view: view, totalPages: totalPages, onCompletion: onCompletion)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        return (sut, view)
    }

    private final class MockOnboardingView: OnboardingView {
        var displayedPage: Int?

        func displayPage(at index: Int) {
            displayedPage = index
        }
    }
}
