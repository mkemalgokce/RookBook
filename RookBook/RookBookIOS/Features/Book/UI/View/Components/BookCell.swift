// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class BookCell: UITableViewCell {
    // MARK: - UI Properties
    public lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25.0
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green3
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

    // MARK: - Properties
    lazy var emptyImage: UIImage? = {
        let image = UIImage(systemName: "photo.on.rectangle.angled")
        let tintedImage = image?.withTintColor(.green1.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        return tintedImage
    }()

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

    // MARK: - Lifecycle Methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.isShimmering = logoImageView.isShimmering
    }

    // MARK: - Internal Methods
    func showEmptyImage() {
        if logoImageView.contentMode == .scaleAspectFill {
            logoImageView.contentMode = .scaleAspectFit
        }
        logoImageView.setImageAnimated(emptyImage)
    }

    func updateLogoImage(_ newImage: UIImage?) {
        if logoImageView.contentMode == .scaleAspectFit {
            logoImageView.contentMode = .scaleAspectFill
        }
        logoImageView.setImageAnimated(newImage)
    }

    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(logoImageView)
        contentView.addSubview(labelVStack)

        labelVStack.addArrangedSubview(nameLabel)
        labelVStack.addArrangedSubview(descriptionLabel)
        labelVStack.addArrangedSubview(authorLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 116),

            labelVStack.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            labelVStack.leadingAnchor.constraint(
                equalTo: logoImageView.trailingAnchor,
                constant: 16
            ),

            labelVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
}
