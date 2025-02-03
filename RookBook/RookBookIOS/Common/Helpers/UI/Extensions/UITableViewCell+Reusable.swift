// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

// MARK: - UITableViewCell+Reusable.swift
extension UITableViewCell: ReusableCell {}

// MARK: - UITableView+Reusable.swift
extension UITableView {
    func dequeueReusable<T: ReusableCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier) as? T else {
            fatalError("Invalid cell type: \(T.self). Identifier: \(T.identifier).")
        }
        return cell
    }

    func register<T: UITableViewCell>(_ cellType: T.Type) where T: ReusableCell {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }
}
