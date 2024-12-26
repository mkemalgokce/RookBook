// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import RookBookIOS
import UIKit

public enum OnboardingUIComposer {
    static func composed(onCompletion: @escaping () -> Void) -> OnboardingViewController {
        let pages = OnboardingPageViewModel.make()
        let textConfiguration = OnboardingPresenter.makeTextConfiguration()

        let vc = OnboardingViewController.make(
            withTextConfiguration: textConfiguration,
            pages: pages
        )

        let presenter = OnboardingPresenter(view: WeakRef(vc), totalPages: pages.count, onCompletion: onCompletion)

        vc.onRightButtonTap = presenter.displayNextPage
        vc.onLeftButtonTap = presenter.displayPreviousPage
        vc.onPageIndexChange = presenter.updatePage

        return vc
    }
}

extension OnboardingViewController {
    fileprivate static func make(
        withTextConfiguration textConfiguration: OnboardingTextConfiguration,
        pages: [OnboardingPageViewModel<UIImage>]
    ) -> OnboardingViewController {
        let vc = OnboardingViewController(pageViewModels: pages)
        vc.onSetupView = { [weak vc] in
            vc?.configureTexts(withConfiguration: textConfiguration)
        }
        return vc
    }
}
