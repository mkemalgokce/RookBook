// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import UIKit

protocol CollectionViewContaining {
    var collectionView: UICollectionView { get }
}

extension CollectionViewContaining {
    func numberOfItems(in section: Int) -> Int {
        collectionView.numberOfSections > section ? collectionView.numberOfItems(inSection: section) : 0
    }

    func cell(item: Int, section: Int) -> UICollectionViewCell? {
        guard numberOfItems(in: section) > item else {
            return nil
        }
        let ds = collectionView.dataSource
        let index = IndexPath(row: item, section: section)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
}

extension CollectionViewContaining where Self: UIViewController {
    func simulateCollectionAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            setSmallFrameToPreventRenderingCells()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    private func setSmallFrameToPreventRenderingCells() {
        collectionView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }
}
