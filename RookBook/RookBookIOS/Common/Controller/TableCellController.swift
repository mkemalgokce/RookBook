// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class TableCellController {
    let id: UUID
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePrefetching: UITableViewDataSourcePrefetching?

    public init(id: UUID, _ dataSource: UITableViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        delegate = dataSource as? UITableViewDelegate
        dataSourcePrefetching = dataSource as? UITableViewDataSourcePrefetching
    }
}

// MARK: - Equatable
extension TableCellController: Equatable {
    public static func ==(lhs: TableCellController, rhs: TableCellController) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension TableCellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
