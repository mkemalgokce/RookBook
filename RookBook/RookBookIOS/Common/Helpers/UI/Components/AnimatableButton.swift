// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public class AnimatableButton: UIButton {
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimationHandlers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupAnimationHandlers() {
        addTarget(self, action: #selector(animateButtonPress), for: [.touchDown, .touchDragEnter])
        addTarget(
            self,
            action: #selector(animateButtonRelease),
            for: [.touchUpInside, .touchCancel, .touchDragExit]
        )
    }

    @objc private func animateButtonPress() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }

    @objc private func animateButtonRelease() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
}
