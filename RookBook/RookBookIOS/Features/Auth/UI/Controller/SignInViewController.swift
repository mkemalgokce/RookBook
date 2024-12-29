// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

public final class SignInViewController: ViewController<SignInView> {
    // MARK: - Properties
    public var mailText: String? {
        get { rootView.mailTextField.text }
        set { rootView.mailTextField.text = newValue }
    }

    public var passwordText: String? {
        get { rootView.passTextField.text }
        set { rootView.passTextField.text = newValue }
    }

    public var onSignIn: (() -> Void)?
    public var onAppleSignIn: (() -> Void)?
    public var onSignUp: (() -> Void)?

    public var appleCredentialsProvider: AppleCredentialsProviding?

    // MARK: - Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
    }

    // MARK: - Private Methods
    private func setupButtonActions() {
        rootView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        rootView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        rootView.signInWithAppleButton
            .addTarget(self, action: #selector(signInWithAppleButtonTapped), for: .touchUpInside)
    }

    @objc private func signInButtonTapped() {
        onSignIn?()
    }

    @objc private func signInWithAppleButtonTapped() {
        onAppleSignIn?()
    }

    @objc private func signUpButtonTapped() {
        onSignUp?()
    }
}

// MARK: - ResourceErrorView & ResourceLoadingView
extension SignInViewController: ResourceErrorView, ResourceLoadingView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        showAlert(message: viewModel.message)
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
}

// MARK: - SignInViewTextConfiguration
extension SignInViewController {
    public func setup(with textConfiguration: SignInViewTextConfiguration) {
        title = textConfiguration.title
        rootView.mailTextField.placeholder = textConfiguration.emailPlaceholder
        rootView.passTextField.placeholder = textConfiguration.passwordPlaceholder
        rootView.signInButton.setTitle(textConfiguration.signInButtonTitle, for: .normal)
        rootView.signInWithAppleButton.setTitle(textConfiguration.signInWithAppleButtonTitle, for: .normal)
        rootView.signUpButton.firstText = textConfiguration.dontHaveAccountText
        rootView.signUpButton.secondText = textConfiguration.signUpButtonTitle
    }
}
