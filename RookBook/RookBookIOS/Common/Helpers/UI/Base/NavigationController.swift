// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class NavigationController: UINavigationController {
    // MARK: - Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupBackButton()
    }

    // MARK: - Private Methods
    private func setupTitle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.green1,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.green1,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupBackButton() {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.green1,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationBar.tintColor = .green1
        navigationBar.standardAppearance.backButtonAppearance = backButtonAppearance
    }
}
