// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

public final class BookViewController: ListTableViewController<BookView> {
    // MARK: - Properties
    var onCreate: (() -> Void)?

    // MARK: - Helpers
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButton()
    }

    private func setupNavigationButton() {
//        navigationItem.rightBarButtonItem = NavigationController
//            .makeCreateButton(target: self, action: #selector(createButtonTapped))
    }

    @objc private func createButtonTapped() {
        onCreate?()
    }
}

// MARK: - BookListViewTextConfiguration
extension BookViewController {
    public func setup(with textConfiguration: BookListViewTextConfiguration) {
        title = textConfiguration.title
    }
}
