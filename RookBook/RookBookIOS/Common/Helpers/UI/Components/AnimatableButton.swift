// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public class AnimatableButton: UIButton {
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimationHandler()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupAnimationHandler() {
        addTarget(self, action: #selector(animateButtonPress), for: .touchUpInside)
    }

    @objc private func animateButtonPress() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
            }
        })
    }
}
