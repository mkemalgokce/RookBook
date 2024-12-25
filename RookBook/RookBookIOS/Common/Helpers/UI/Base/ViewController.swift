// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

class ViewController<View: UIView>: UIViewController {
    // MARK: - Properties
    var rootView: View {
        return view as! View
    }
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        view = View()
    }
}
