// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

extension OnboardingPresenter {
    public static var title: String {
        NSLocalizedString(
            "Onboarding View Title",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding view title"
        )
    }

    public static var title1: String {
        NSLocalizedString(
            "Onboarding Title 1",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page first title"
        )
    }

    public static var subtitle1: String {
        NSLocalizedString(
            "Onboarding Subtitle 1",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page first subtitle"
        )
    }

    public static var title2: String {
        NSLocalizedString(
            "Onboarding Title 2",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page second title"
        )
    }

    public static var subtitle2: String {
        NSLocalizedString(
            "Onboarding Subtitle 2",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page second subtitle"
        )
    }

    public static var title3: String {
        NSLocalizedString(
            "Onboarding Title 3",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page third title"
        )
    }

    public static var subtitle3: String {
        NSLocalizedString(
            "Onboarding Subtitle 3",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page third subtitle"
        )
    }

    public static var nextButtonTitle: String {
        NSLocalizedString(
            "Next Button Title",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page next button title"
        )
    }

    public static var previousButtonTitle: String {
        NSLocalizedString(
            "Previous Button Title",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page previous button title"
        )
    }

    public static var finishButtonTitle: String {
        NSLocalizedString(
            "Finish Button Title",
            tableName: "Onboarding",
            bundle: Bundle(for: Self.self),
            comment: "Onboarding page finish button title"
        )
    }
}
