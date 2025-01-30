// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class BookCell: UITableViewCell {
    // MARK: - UI Properties
    public lazy var logoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green3
        view.layer.cornerRadius = 25.0
        view.clipsToBounds = true
        return view
    }()

    public lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()

    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .green1
        label.text = "Title"
        label.numberOfLines = 1
        return label
    }()

    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .green2
        label.text = "Description"
        label.numberOfLines = 3
        return label
    }()

    public lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textColor = .green1
        label.text = "Title"
        label.numberOfLines = 1
        return label
    }()

    private lazy var labelVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var retryButton: UIButton = {
        let button = AnimatableButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let largeImage = UIImage(systemName: "arrow.clockwise", withConfiguration: largeConfig)
        button.setImage(largeImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .green1.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Properties
    lazy var emptyImage: UIImage? = {
        let image = UIImage(systemName: "photo.on.rectangle.angled")
        let tintedImage = image?.withTintColor(.green1.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        return tintedImage
    }()

    var onRetry: (() -> Void)?

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods
    func showEmptyImage() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setImageAnimated(emptyImage)
    }

    func updateLogoImage(_ newImage: UIImage?) {
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.setImageAnimated(newImage)
    }

    func showRetryButton() {
        retryButton.isHidden = false
        logoImageView.isHidden = true
    }

    func hideRetryButton() {
        retryButton.isHidden = true
        logoImageView.isHidden = false
    }

    // MARK: - Private Methods
    @objc private func retryButtonTapped() {
        onRetry?()
        print("Retry button tapped")
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        logoContainerView.addSubview(logoImageView)
        logoContainerView.addSubview(retryButton)

        contentView.addSubview(logoContainerView)
        contentView.addSubview(labelVStack)

        labelVStack.addArrangedSubview(nameLabel)
        labelVStack.addArrangedSubview(descriptionLabel)
        labelVStack.addArrangedSubview(authorLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Logo Container View
            logoContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            logoContainerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            logoContainerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
            logoContainerView.widthAnchor.constraint(equalToConstant: 100),
            logoContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Logo Image View
            logoImageView.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor),
            logoImageView.topAnchor.constraint(equalTo: logoContainerView.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: logoContainerView.bottomAnchor),

            // Retry Button
            retryButton.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 50),
            retryButton.heightAnchor.constraint(equalToConstant: 50),

            // Label Stack
            labelVStack.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            labelVStack.leadingAnchor.constraint(
                equalTo: logoContainerView.trailingAnchor,
                constant: 16
            ),

            labelVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)

        ])
    }
}
