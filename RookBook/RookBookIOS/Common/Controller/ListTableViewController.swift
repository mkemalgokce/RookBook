// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public protocol ListTableView: UIView {
    var tableView: UITableView { get }
    var refreshControl: UIRefreshControl { get }
    var isTableViewEmpty: Bool { get set }
}

public class ListTableViewController<ListView: ListTableView>: ViewController<ListView>,
    UITableViewDataSourcePrefetching, UITableViewDelegate {
    // MARK: - Properties
    private lazy var dataSource = UITableViewDiffableDataSource<Int, TableCellController>(tableView: rootView
        .tableView) { tableView, indexPath, controller in
            controller.dataSource.tableView(tableView, cellForRowAt: indexPath)
        }

    public var onRefresh: (() -> Void)?
    public var onDelete: ((UUID) -> Void)?

    // MARK: - Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        refresh()
    }

    // MARK: - Public Methods
    public func display(_ sections: [TableCellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TableCellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }

        dataSource.apply(snapshot)
        rootView.isTableViewEmpty = (sections.first?.isEmpty == true)
    }

    // MARK: - Table View Methods
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    public func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
            dsp?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
        .delete
    }

    public func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let controller = self?.cellController(at: indexPath) else { return }
            self?.onDelete?(controller.id)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }

    // MARK: - Helpers
    @objc private func refresh() {
        onRefresh?()
        rootView.tableView.refreshControl?.endRefreshing()
    }

    private func setupTableView() {
        dataSource.defaultRowAnimation = .fade
        rootView.tableView.dataSource = dataSource
        rootView.tableView.delegate = self
        rootView.tableView.prefetchDataSource = self
        rootView.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    private func cellController(at indexPath: IndexPath) -> TableCellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}
