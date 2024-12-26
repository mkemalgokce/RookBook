// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension UICollectionView {
    func isScrolledToItem(to index: Int) -> Bool {
        contentOffset.x == frame.width * CGFloat(index)
    }
}
