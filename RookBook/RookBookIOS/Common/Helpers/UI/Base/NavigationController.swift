// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class NavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }

    private func setupTitle() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.green1,
            .font: UIFont.systemFont(ofSize: 34, weight: .black)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.green1,
            .font: UIFont.systemFont(ofSize: 34, weight: .black)
        ]
        navigationBar.standardAppearance = appearance
    }
}
