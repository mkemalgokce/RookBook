// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

extension OnboardingPageViewModel<UIImage> {
    public static func make() -> [Self] {
        [
            OnboardingPageViewModel(
                title: OnboardingPresenter.title1,
                subtitle: OnboardingPresenter.subtitle1,
                image: .pandaReadBook
            ),

            OnboardingPageViewModel(
                title: OnboardingPresenter.title2,
                subtitle: OnboardingPresenter.subtitle2,
                image: .booksWithChecklist
            ),

            OnboardingPageViewModel(
                title: OnboardingPresenter.title3,
                subtitle: OnboardingPresenter.subtitle3,
                image: .catTeaching
            )
        ]
    }
}
