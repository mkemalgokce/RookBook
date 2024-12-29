// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class OnboardingPresenterLocalizationTests: XCTestCase {
    private let bundle = Bundle(for: OnboardingPresenter.self)
    private let table = "Onboarding"

    func test_localizedProperties_haveKeysAndValuesForAllSupportedLocales() {
        assertAllLocalizedKeysAndValuesExist(in: bundle, table)
    }

    // swiftlint:disable function_body_length
    func test_localizedProperties_returnCorrectValues() {
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title,
            key: "Onboarding View Title",
            table: table,
            bundle: bundle
        )

        // Page 1
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title1,
            key: "Onboarding Title 1",
            table: table,
            bundle: bundle
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.subtitle1,
            key: "Onboarding Subtitle 1",
            table: table,
            bundle: bundle
        )

        // Page 2
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title2,
            key: "Onboarding Title 2",
            table: table,
            bundle: bundle
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.subtitle2,
            key: "Onboarding Subtitle 2",
            table: table,
            bundle: bundle
        )

        // Page 3
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.title3,
            key: "Onboarding Title 3",
            table: table,
            bundle: bundle
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.subtitle3,
            key: "Onboarding Subtitle 3",
            table: table,
            bundle: bundle
        )

        // Button Titles
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.nextButtonTitle,
            key: "Next Button Title",
            table: table,
            bundle: bundle
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.previousButtonTitle,
            key: "Previous Button Title",
            table: table,
            bundle: bundle
        )
        assertPropertyMatchesLocalizedString(
            OnboardingPresenter.finishButtonTitle,
            key: "Finish Button Title",
            table: table,
            bundle: bundle
        )
    }
    // swiftlint:enable function_body_length
}
