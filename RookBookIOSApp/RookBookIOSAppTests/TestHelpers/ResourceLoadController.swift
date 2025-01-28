// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
import UIKit

protocol ResourceLoadController: UIViewController {
    var refreshControl: UIRefreshControl { get }
}

extension ResourceLoadController {
    func simulateUserInitiatedReload() {
        refreshControl.simulatePullToRefresh()
    }
}

protocol TableViewResourceLoadController: ResourceLoadController {
    var tableView: UITableView { get }
}

protocol CollectionViewResourceLoadController: ResourceLoadController {
    var collectionView: UICollectionView { get }
}

extension CollectionViewResourceLoadController {
    func numberOfRenderedCells() -> Int {
        collectionView.numberOfItems(inSection: resourceSection)
    }

    func resource(at row: Int) -> UICollectionViewCell? {
        guard numberOfRenderedCells() > row else { return nil }
        let dataSource = collectionView.dataSource
        let index = IndexPath(row: row, section: resourceSection)
        return dataSource?.collectionView(collectionView, cellForItemAt: index)
    }

    @discardableResult
    func simulateCellVisible<T: UICollectionViewCell>(at index: Int) -> T? {
        resource(at: index) as? T
    }

    @discardableResult
    func simulateCellNotVisible<T: UICollectionViewCell>(at index: Int) -> T? {
        let cell = simulateCellVisible(at: index)!

        let delegate = collectionView.delegate
        let index = IndexPath(row: index, section: resourceSection)
        delegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: index)
        return cell as? T
    }

    func simulateCellNearVisible(at index: Int) {
        let dataSource = collectionView.prefetchDataSource
        let index = IndexPath(row: index, section: resourceSection)
        dataSource?.collectionView(collectionView, prefetchItemsAt: [index])
    }

    func simulateCellNotNearVisible(at index: Int) {
        simulateCellNearVisible(at: index)

        let dataSource = collectionView.prefetchDataSource
        let index = IndexPath(row: index, section: resourceSection)
        dataSource?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [index])
    }

    private var resourceSection: Int {
        0
    }
}

extension TableViewResourceLoadController {
    func numberOfRenderedCells() -> Int {
        numberOfRows(in: resourceSection)
    }

    func resource(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedCells() > row else { return nil }
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: resourceSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }

    @discardableResult
    func simulateCellVisible<T: UITableViewCell>(at index: Int) -> T? {
        resource(at: index) as? T
    }

    @discardableResult
    func simulateCellNotVisible<T: UITableViewCell>(at index: Int) -> T? {
        let cell = simulateCellVisible(at: index)!

        let delegate = tableView.delegate
        let index = IndexPath(row: index, section: resourceSection)
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: index)
        return cell as? T
    }

    func simulateCellNearVisible(at index: Int) {
        let dataSource = tableView.prefetchDataSource
        let index = IndexPath(row: index, section: resourceSection)
        dataSource?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateCellNotNearVisible(at index: Int) {
        simulateCellNearVisible(at: index)

        let dataSource = tableView.prefetchDataSource
        let index = IndexPath(row: index, section: resourceSection)
        dataSource?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }

    private var resourceSection: Int {
        0
    }
}

extension ListTableViewController: TableViewResourceLoadController {
    var tableView: UITableView {
        rootView.tableView
    }

    var refreshControl: UIRefreshControl {
        rootView.refreshControl
    }
}

// extension ListCollectionViewController: CollectionViewResourceLoadController {}
