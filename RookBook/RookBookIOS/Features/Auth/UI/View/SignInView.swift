// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class SignInView: UIView {
    // MARK: - UI Properties
    lazy var mailTextField: RoundedTextField = {
        let field = RoundedTextField()
        field.placeholder = "Mailasd"
        field.backgroundColor = .green3
        field.placeholderColor = .green1
        field.textColor = .green1
        field.font = .boldSystemFont(ofSize: 20)
        return field
    }()

    lazy var passTextField: RoundedTextField = {
        let field = RoundedTextField(isSecure: true)
        field.placeholder = "Passwordads"
        field.backgroundColor = .green3
        field.placeholderColor = .green1
        field.textColor = .green1
        field.font = .boldSystemFont(ofSize: 20)
        return field
    }()

    lazy var signInButton: RoundedButton = {
        let button = RoundedButton(title: "Sign In", backgroundColor: .green1, textColor: .white)
        return button
    }()

    lazy var signInWithAppleButton: RoundedButton = {
        let appleLogoImage = UIImage(systemName: "apple.logo")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = RoundedButton(
            title: "Sign In With Apple", backgroundColor: .black.withAlphaComponent(0.7),
            textColor: .white,
            iconImage: appleLogoImage
        )

        return button
    }()

    lazy var signUpButton: FooterButton = {
        let button = FooterButton(firstText: "Don't have an account?", secondText: "Sign Up")
        button.firstColor = .green2
        button.secondColor = .green1
        return button
    }()

    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView(image: .dogSleeping)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var dividerView: DividerView = {
        let divider = DividerView()
        return divider
    }()

    private lazy var bodyVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mailTextField, passTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var bottomVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signInButton, signInWithAppleButton, dividerView, signUpButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        //applyGradient(colors: [.green3, .green4])
    }

    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .red
        addSubview(bodyVStack)
        addSubview(bottomVStack)
        addSubview(topImageView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            topImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topImageView.widthAnchor.constraint(
                lessThanOrEqualTo: bottomVStack.widthAnchor,
                multiplier: 3 / 4
            ),
            topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor),

            bottomVStack.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            bottomVStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            bottomVStack.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            bottomVStack.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),

            bodyVStack.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -8),

            bodyVStack.widthAnchor.constraint(
                equalTo: safeAreaLayoutGuide.widthAnchor,
                constant: -32
            ),
            bodyVStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            bodyVStack.bottomAnchor.constraint(
                equalTo: bottomVStack.topAnchor,
                constant: -8
            ),

            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
