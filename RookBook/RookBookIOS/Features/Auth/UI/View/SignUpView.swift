// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class SignUpView: UIView {
    // MARK: - UI Properties
    lazy var fullNameTextField: RoundedTextField = {
        let field = RoundedTextField()
        field.placeholder = "Full Name"
        field.backgroundColor = .green3
        field.placeholderColor = .green1
        field.textColor = .green1
        field.font = .boldSystemFont(ofSize: 20)
        field.autocapitalizationType = .words
        field.autocorrectionType = .no
        field.keyboardType = .namePhonePad
        field.returnKeyType = .continue
        return field
    }()

    lazy var mailTextField: RoundedTextField = {
        let field = RoundedTextField()
        field.placeholder = "Mail"
        field.backgroundColor = .green3
        field.placeholderColor = .green1
        field.textColor = .green1
        field.font = .boldSystemFont(ofSize: 20)
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
    }()

    lazy var passTextField: RoundedTextField = {
        let field = RoundedTextField(isSecure: true)
        field.placeholder = "Password"
        field.backgroundColor = .green3
        field.placeholderColor = .green1
        field.textColor = .green1
        field.font = .boldSystemFont(ofSize: 20)
        field.keyboardType = .default
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.autocorrectionType = .no
        return field
    }()

    lazy var signUpButton: RoundedButton = {
        let button = RoundedButton(title: "Sign Up", backgroundColor: .green1, textColor: .white)
        return button
    }()

    lazy var signUpWithAppleButton: RoundedButton = {
        let button = RoundedButton(
            title: "Sign Up With Apple", backgroundColor: .black.withAlphaComponent(0.7),
            textColor: .white,
            iconImage: UIImage(systemName: "apple.logo")?
                .withTintColor(.white, renderingMode: .alwaysOriginal)
        )

        return button
    }()

    lazy var signInButton: FooterButton = {
        let button = FooterButton(firstText: "Already have an account?", secondText: "Sign In")
        button.firstColor = .green2
        button.secondColor = .green1
        return button
    }()

    private lazy var dividerView: DividerView = {
        let divider = DividerView()
        return divider
    }()

    private lazy var bodyVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameTextField, mailTextField, passTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var bottomVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signUpButton, signUpWithAppleButton, dividerView, signInButton])
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

    // MARK: - Lifecycle Methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(colors: [.green3, .green4])
    }

    // MARK: - Private Methods
    private func setupView() {
        addSubview(bodyVStack)
        addSubview(bottomVStack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            bottomVStack.topAnchor.constraint(equalTo: bodyVStack.bottomAnchor, constant: 16),
            bottomVStack.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomVStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            bottomVStack.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            bottomVStack.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),

            bodyVStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),

            bodyVStack.widthAnchor.constraint(
                equalTo: safeAreaLayoutGuide.widthAnchor,
                constant: -32
            ),
            bodyVStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            bodyVStack.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomVStack.topAnchor,
                constant: 96
            ),

            bodyVStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3)

        ])
    }
}
