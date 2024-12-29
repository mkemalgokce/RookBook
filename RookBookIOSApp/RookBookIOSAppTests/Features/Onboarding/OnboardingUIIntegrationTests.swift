// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
@testable import RookBookIOSApp
import RookBookCore
import XCTest

final class OnboardingUIIntegrationTests: XCTestCase {
    func test_onboardingView_hasTitle() {
        let sut = makeSUT()
        sut.simulateCollectionAppearance()
        XCTAssertEqual(sut.title, onboardingTitle)
    }

    func test_onboardingView_viewDidLoad_callsSetupView() {
        let sut = makeSUT()
        var setupViewCallCount = 0
        sut.onSetupView = { setupViewCallCount += 1 }
        sut.loadViewIfNeeded()
        XCTAssertEqual(setupViewCallCount, 1)
    }

    func test_onboardingView_hasThreePages() {
        let sut = makeSUT()
        sut.simulateCollectionAppearance()
        XCTAssertEqual(sut.rootView.pageControl.numberOfPages, 3)
    }

    func test_rightButton_updatesPageControl() {
        let sut = makeSUT()
        sut.simulateCollectionAppearance()
        XCTAssertEqual(sut.currentPage, 0)

        sut.simulateNextButtonTap()
        XCTAssertEqual(sut.currentPage, 1)

        sut.simulateNextButtonTap()
        XCTAssertEqual(sut.currentPage, 2)

        sut.simulateNextButtonTap()
        XCTAssertEqual(sut.currentPage, 2)
    }

    func test_previousButton_updatesPageControl() {
        let sut = makeSUT()
        sut.simulateCollectionAppearance()
        XCTAssertEqual(sut.currentPage, 0)

        sut.simulateNextButtonTap()
        sut.simulateNextButtonTap()
        XCTAssertEqual(sut.currentPage, 2)

        sut.simulatePreviousButtonTap()
        XCTAssertEqual(sut.currentPage, 1)

        sut.simulatePreviousButtonTap()
        XCTAssertEqual(sut.currentPage, 0)

        sut.simulatePreviousButtonTap()
        XCTAssertEqual(sut.currentPage, 0)
    }

    func test_pages_hasCorrectContent() {
        let sut = makeSUT()
        sut.simulateCollectionAppearance()

        let firstPage = page(at: 0)
        let secondPage = page(at: 1)
        let thirdPage = page(at: 2)

        let firstCell = sut.onboardingCell(at: 0)
        let secondCell = sut.onboardingCell(at: 1)
        let thirdCell = sut.onboardingCell(at: 2)

        XCTAssertTrue(cellHasPage(firstCell, page: firstPage))
        XCTAssertTrue(cellHasPage(secondCell, page: secondPage))
        XCTAssertTrue(cellHasPage(thirdCell, page: thirdPage))
    }

    func test_onboardingView_onCompletion() {
        var completionCallCount = 0
        let sut = makeSUT(onCompletion: { completionCallCount += 1 })
        sut.simulateCollectionAppearance()

        XCTAssertEqual(completionCallCount, 0)
        sut.simulateNextButtonTap()
        XCTAssertEqual(completionCallCount, 0)
        sut.simulateNextButtonTap()
        XCTAssertEqual(completionCallCount, 0)
        sut.simulateNextButtonTap()
        XCTAssertEqual(completionCallCount, 1)
        sut.simulateNextButtonTap()
        XCTAssertEqual(completionCallCount, 2)
    }

    func test_onboardingView_scrollToPage() {
        let sut = makeSUT()
        sut.simulateCollectionAppearance()

        sut.simulateScroll(to: 1)
        XCTAssertTrue(sut.collectionView.isScrolledToItem(to: 1))
        XCTAssertEqual(sut.currentPage, 1)

        sut.simulateScroll(to: 0)
        XCTAssertTrue(sut.collectionView.isScrolledToItem(to: 0))
        XCTAssertEqual(sut.currentPage, 0)

        sut.simulateScroll(to: 2)
        XCTAssertTrue(sut.collectionView.isScrolledToItem(to: 2))
        XCTAssertEqual(sut.currentPage, 2)

        sut.simulateScroll(to: 4)
        XCTAssertTrue(sut.collectionView.isScrolledToItem(to: 2))
        XCTAssertEqual(sut.currentPage, 2)
    }

    // MARK: - Helpers
    private typealias Page = OnboardingPageViewModel<UIImage>
    private func makeSUT(onCompletion: @escaping () -> Void = {}, file: StaticString = #file,
                         line: UInt = #line) -> OnboardingViewController {
        let sut = OnboardingUIComposer.composed(onCompletion: onCompletion)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func page(at index: Int) -> OnboardingPageViewModel<UIImage> {
        Page.make()[index]
    }

    private func cellHasPage(_ cell: OnboardingCell?, page: Page) -> Bool {
        guard let cell else { return false }
        return cell.title == page.title && cell.subtitle == page.subtitle && cell.image == page.image
    }
}
