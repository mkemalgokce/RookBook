// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public class AnimatableButton: UIButton {
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(animateButtonPress), for: [.touchDown, .touchDragEnter])
        addTarget(
            self,
            action: #selector(animateButtonRelease),
            for: [.touchUpInside, .touchCancel, .touchDragExit]
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    @objc private func animateButtonPress() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    @objc private func animateButtonRelease() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
