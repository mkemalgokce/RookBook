// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation
import RookBookCore
import RookBookIOS
import UIKit

final class BookViewAdapter: ResourceView {
    // MARK: - Properties
    weak var controller: BookViewController?
    private let loadImage: (URL) -> AnyPublisher<Data, Error>

    // MARK: - Initializers
    init(controller: BookViewController? = nil, loadImage: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.loadImage = loadImage
    }

    // MARK: - Internal Methods
    func display(_ viewModel: [RookBookCore.Book]) {
        guard let controller else { return }
        let cellControllers: [TableCellController] = viewModel.compactMap { book in
            let view = BookCellController(
                viewModel: BookCellPresenter.map(book),
                selection: {}
            )

            if let imageURL = book.coverImage {
                let presenter = LoadResourcePresenter(
                    errorView: view,
                    loadingView: view
                )

                let loader = loadImage(imageURL)
                    .tryMap(UIImage.tryMake)
                    .eraseToAnyPublisher()
                
                view.requestImage = { [weak presenter] in
                    presenter?.load(on: view, loader: { loader })
                }
                
                view.cancelImageRequest = { [weak presenter] in
                    presenter?.cancel()
                }
            }

            return TableCellController(id: book.id, view)
        }

        controller.display(cellControllers)
    }
}

