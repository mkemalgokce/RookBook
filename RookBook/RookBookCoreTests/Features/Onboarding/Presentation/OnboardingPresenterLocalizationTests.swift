// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class OnboardingPresenterLocalizationTests: XCTestCase {
    private let bundle = Bundle(for: OnboardingPresenter.self)
    private let table = "Onboarding"

    func test_localizedProperties_haveKeysAndValuesForAllSupportedLocales() {
        assertAllLocalizedKeysAndValuesExist(in: bundle, table)
    }

    func test_localizedProperties_returnCorrectValues() {
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title,
            key: "Onboarding View Title"
        )

        // Page 1
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title1,
            key: "Onboarding Title 1"
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.subtitle1,
            key: "Onboarding Subtitle 1"
        )

        // Page 2
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title2,
            key: "Onboarding Title 2"
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.subtitle2,
            key: "Onboarding Subtitle 2"
        )

        // Page 3
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title3,
            key: "Onboarding Title 3"
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.subtitle3,
            key: "Onboarding Subtitle 3"
        )

        // Button Titles
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.nextButtonTitle,
            key: "Next Button Title"
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.previousButtonTitle,
            key: "Previous Button Title"
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.finishButtonTitle,
            key: "Finish Button Title"
        )
    }

    // MARK: - Helpers
    private func assertPropertyMatchesLocalizedString(
        _ value: String,
        key: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            value,
            localized(key, table: table, bundle: bundle),
            file: file,
            line: line
        )
    }
}
