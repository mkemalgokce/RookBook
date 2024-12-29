// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
@testable import SnapShooter
import XCTest

final class OnboardingSnapshotTests: XCTestCase {
    func test_onboarding_first_page_dark() {
        let (_, nc) = makeSUT()

        let image = nc.snapshot(for: .iPhone13(style: .dark))

        assert(image)
    }

    func test_onboarding_second_page_light() {
        let (sut, nc) = makeSUT()

        sut.displayPage(at: 1)

        assert(nc.snapshot())
    }

    func test_onboarding_third_page_light() {
        let (sut, nc) = makeSUT()
        sut.displayPage(at: 2)

        assert(nc.snapshot())
    }

    // MARK: - Helpers
    private typealias Page = OnboardingPageViewModel<UIImage>

    private func makeSUT() -> (OnboardingViewController, UINavigationController) {
        let sut = OnboardingViewController(pageViewModels: stubOnboardingPages())
        let nc = NavigationController(rootViewController: sut)

        sut.title = OnboardingPresenter.title
        nc.loadViewIfNeeded()
        sut.loadViewIfNeeded()

        nc.view.layoutIfNeeded()
        return (sut, nc)
    }

    private func stubOnboardingPages() -> [Page] {
        [
            Page(
                title: "First Title Text Message",
                subtitle: "It's a multiline first text message.\n New line is here.",
                image: UIImage.make(withColor: .red)
            ),
            Page(
                title: "Second Title Text Message",
                subtitle: "It's a single line second text message.",
                image: UIImage.make(withColor: .green)
            ),
            Page(
                title: "Third Title Text Message",
                subtitle: "It's a multiline third text message.\n New line is here.\n Another line is here.",
                image: UIImage.make(withColor: .blue)
            )
        ]
    }
}
