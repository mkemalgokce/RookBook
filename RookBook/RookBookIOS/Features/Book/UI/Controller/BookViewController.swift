// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

public final class BookViewController: ListTableViewController<BookView> {
    // MARK: - Properties
    var onCreate: (() -> Void)?
    var onAdd: (() -> Void)?

    // MARK: - Helpers
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButton()
    }

    private func setupNavigationButton() {
        addPlusButtonToNavigationBar(target: self, action: #selector(plusButtonTapped))
    }

    @objc private func createButtonTapped() {
        onCreate?()
    }

    @objc private func plusButtonTapped() {
        onAdd?()
    }
}

// MARK: - BookListViewTextConfiguration
extension BookViewController {
    public func setup(with textConfiguration: BookListViewTextConfiguration) {
        title = textConfiguration.title
    }
}
