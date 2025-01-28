// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
import UIKit

extension ListTableViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            setSmallFrameToPreventRenderingCells()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    private func prepareForFirstAppearance() {
        setSmallFrameToPreventRenderingCells()
    }

    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }
}

extension SignInViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}

extension SignUpViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}
