// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import RookBookIOS
import UIKit

final class BookStub: ImageCellControllerDelegate {
    let viewModel: BookCellViewModel
    let image: UIImage?
    weak var controller: BookCellController?

    init(name: String, description: String, author: String, image: UIImage?) {
        self.image = image
        viewModel = BookCellViewModel(name: name, description: description, author: author)
    }

    func didRequestImage() {
        controller?.display(.init(isLoading: false))

        if let image {
            controller?.display(image)
        } else {
            controller?.display(.error(message: "any"))
        }
    }

    func didCancelImageRequest() {}
}
