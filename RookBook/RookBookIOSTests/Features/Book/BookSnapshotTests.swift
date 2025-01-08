// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
@testable import RookBookIOS
import SnapShooter
import XCTest

final class BookSnapshotTests: XCTestCase {
    func test_emptyState_light() {
        let (sut, nc) = makeSUT()
        sut.display([])
        assert(nc.snapshot())
    }

    func test_filledState_dark() {
        let (sut, nc) = makeSUT()
        sut.display(BookStub.bookWithContent())
        assert(nc.snapshot(for: .iPhone13(style: .dark)))
    }

    func test_failedImageLoading_dark() {
        let (sut, nc) = makeSUT()
        sut.display(BookStub.bookWithFailedImageLoading())
        assert(nc.snapshot(for: .iPhone13(style: .dark)))
    }

    // MARK: - Helpers
    private func makeSUT() -> (BookViewController, UINavigationController) {
        let sut = BookViewController()
        let nc = NavigationController(rootViewController: sut)
        sut.title = BookListPresenter.title
        return (sut, nc)
    }
}

extension BookViewController {
    func display(_ stubs: [BookStub]) {
        let cells: [TableCellController] = stubs.map { stub in
            let cellController = BookCellController(delegate: stub, viewModel: stub.viewModel, selection: {})
            stub.controller = cellController
            return TableCellController(id: UUID(), cellController)
        }
        display(cells)
    }
}
