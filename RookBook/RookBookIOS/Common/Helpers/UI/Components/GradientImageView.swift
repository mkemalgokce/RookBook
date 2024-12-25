// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class GradientImageView: UIView {
    // MARK: - UI Properties
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - Properties
    var gradientColors: [UIColor] {
        didSet {
            setNeedsLayout()
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    // MARK: - Initializers
    init(colors: [UIColor] = []) {
        gradientColors = colors
        super.init(frame: .zero)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(customFrame: imageView.frame, colors: gradientColors)
        mask = imageView
    }
}
