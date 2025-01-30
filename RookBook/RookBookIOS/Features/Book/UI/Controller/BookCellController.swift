// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.
import RookBookCore
import UIKit

public final class BookCellController: NSObject {
    // MARK: - Properties
    public var requestImage: (() -> Void)?
    public var cancelImageRequest: (() -> Void)?

    private let viewModel: BookCellViewModel
    private let selection: () -> Void
    private var cell: BookCell?

    // MARK: - Initializers
    public init(viewModel: BookCellViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

// MARK: - TableView Delegate & DataSource & DataSourcePrefetching
extension BookCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    // MARK: - Public Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusable()
        cell?.nameLabel.text = viewModel.name
        cell?.descriptionLabel.text = viewModel.description
        cell?.authorLabel.text = viewModel.author
        cell?.showEmptyImage()
        requestImage?()
        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        preload(cell: cell)
    }

    public func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cancelLoad()
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        requestImage?()
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }

    // MARK: - Private Methods
    private func preload(cell: UITableViewCell) {
        self.cell = cell as? BookCell
        requestImage?()
    }

    private func cancelLoad() {
        releaseCellForReuse()
        cancelImageRequest?()
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

// MARK: - ResourceView & ResourceLoadingView & ResourceErrorView
extension BookCellController: ResourceView, ResourceLoadingView, ResourceErrorView {
    // MARK: - Typealiases
    public typealias ViewModel = UIImage

    // MARK: - Public Methods
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.logoImageView.isShimmering = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.showRetryButton()
    }

    public func display(_ viewModel: UIImage) {
        cell?.updateLogoImage(viewModel)
    }
}
