// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public class ViewController<View: UIView>: UIViewController {
    // MARK: - Properties
    var rootView: View {
        view as! View
    }

    // MARK: - Lifecycle Methods
    override public func loadView() {
        view = View()
    }
}
