// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
import UIKit

extension OnboardingViewController: CollectionViewContaining {
    var collectionView: UICollectionView {
        rootView.collectionView
    }

    func simulateScroll(to pageIndex: Int) {
        let targetOffset = CGPoint(x: CGFloat(pageIndex) * collectionView.frame.width, y: 0)
        let targetContentOffset = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
        defer { targetContentOffset.deallocate() }
        targetContentOffset.pointee = targetOffset

        collectionView.delegate?.scrollViewWillEndDragging?(
            collectionView,
            withVelocity: .zero,
            targetContentOffset: targetContentOffset
        )
    }

    func onboardingCell(at index: Int) -> OnboardingCell? {
        cell(item: index, section: sectionNumber) as? OnboardingCell
    }

    private var sectionNumber: Int {
        0
    }

    var currentPage: Int {
        rootView.pageControl.currentPage
    }

    func simulateNextButtonTap() {
        rootView.rightButton.simulateTap()
    }

    func simulatePreviousButtonTap() {
        rootView.previousButton.simulateTap()
    }
}
