// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class OnboardingCell: UICollectionViewCell {
    // MARK: - Static Properties
    static let identifier = String(describing: OnboardingCell.self)

    // MARK: - UI Properties
    lazy var titleLabel: TitleLabel = {
        let view = TitleLabel()
        view.numberOfLines = 2
        view.gradientColors = [.green1, .green2]
        view.alignment = .center
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 3
        view.textColor = .green1
        view.textAlignment = .center
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods
    func configure(title: String, subtitle: String, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
    }

    // MARK: - Private Methods
    private func setupView() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -64),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -64),
            subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -64),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
