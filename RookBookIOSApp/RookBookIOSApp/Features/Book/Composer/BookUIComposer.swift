// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation
import RookBookCore
import RookBookIOS

enum BookUIComposer {
    static func composed(loadBooks: @escaping () -> AnyPublisher<[Book], Error>,
                         loadImage: @escaping (URL) -> AnyPublisher<Data, Error>,
                         onSelection: @escaping (Book) -> Void) {
        let vc = BookViewController()
        let presenter = LoadResourcePresenter(errorView: WeakRef(vc), loadingView: WeakRef(vc))
        let bookView = BookViewAdapter(controller: vc, loadImage: loadImage)

        vc.onRefresh = { presenter.load(on: bookView, loader: loadBooks) }
    }
}

extension BookViewController {
    fileprivate static func make(with textConfiguration: BookListViewTextConfiguration) -> BookViewController {
        let vc = BookViewController()
        vc.setup(with: textConfiguration)
        return vc
    }
}
