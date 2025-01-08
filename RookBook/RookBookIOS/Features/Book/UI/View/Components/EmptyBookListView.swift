// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class EmptyBookListView: UIView {
    // MARK: - UI Properties
    private lazy var crocodileImageView: UIImageView = {
        let imageView = UIImageView(image: .crocodileHoldBook)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.6
        return imageView
    }()

    private lazy var plusSymbolImageView: GradientButton = {
        let imageView = GradientButton(colors: [.green3, .green4])
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 80, weight: .bold))
        imageView.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Let's create notes!"
        label.textColor = .green2
        return label
    }()

    private lazy var circleBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = .green2
        view.alpha = 0.4
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupViews()
    }

    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        circleBackground.applyGradient(radius: 32, colors: [.green1, .green2])
    }

    // MARK: - Private Methods
    private func setupViews() {
        addSubview(circleBackground)
        addSubview(messageLabel)

        addSubview(crocodileImageView)
        addSubview(plusSymbolImageView)
        NSLayoutConstraint.activate([
            crocodileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            crocodileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            crocodileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            crocodileImageView.heightAnchor.constraint(equalTo: crocodileImageView.widthAnchor),

            circleBackground.topAnchor.constraint(equalTo: crocodileImageView.topAnchor),
            circleBackground.bottomAnchor.constraint(equalTo: crocodileImageView.bottomAnchor),
            circleBackground.leadingAnchor.constraint(equalTo: crocodileImageView.leadingAnchor),
            circleBackground.trailingAnchor.constraint(equalTo: crocodileImageView.trailingAnchor),

            plusSymbolImageView.trailingAnchor.constraint(
                equalTo: crocodileImageView.trailingAnchor,
                constant: -32
            ),
            plusSymbolImageView.topAnchor.constraint(
                equalTo: crocodileImageView.topAnchor,
                constant: 50
            ),
            plusSymbolImageView.widthAnchor.constraint(equalToConstant: 80),
            plusSymbolImageView.heightAnchor.constraint(equalToConstant: 80),

            messageLabel.topAnchor.constraint(
                equalTo: crocodileImageView.bottomAnchor,
                constant: 20
            ),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
