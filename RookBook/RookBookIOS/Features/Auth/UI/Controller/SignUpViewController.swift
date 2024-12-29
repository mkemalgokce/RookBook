// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit
import RookBookCore

final class SignUpViewController: ViewController<SignUpView> {
    // MARK: - Properties
    public var fullNameText: String? {
        get { rootView.fullNameTextField.text }
        set { rootView.fullNameTextField.text = newValue }
    }

    public var mailText: String? {
        get { rootView.mailTextField.text }
        set { rootView.mailTextField.text = newValue }
    }

    public var passwordText: String? {
        get { rootView.passTextField.text }
        set { rootView.passTextField.text = newValue }
    }

    public var onSignIn: (() -> Void)?
    public var onSignUp: (() -> Void)?
    public var onAppleSignUp: (() -> Void)?

    // MARK: - Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
    }

    // MARK: - Private Methods
    private func setupButtonActions() {
        rootView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        rootView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        rootView.signUpWithAppleButton
            .addTarget(self, action: #selector(signUpWithAppleButtonTapped), for: .touchUpInside)
    }

    @objc private func signInButtonTapped() {
        onSignIn?()
    }

    @objc private func signUpButtonTapped() {
        onSignUp?()
    }

    @objc private func signUpWithAppleButtonTapped() {
        onAppleSignUp?()
    }
}


// MARK: - SignUpViewTextConfiguration
extension SignUpViewController {
    func setup(with textConfiguration: SignUpViewTextConfiguration) {
        title = textConfiguration.title
        rootView.fullNameTextField.placeholder = textConfiguration.fullNameTextFieldPlaceholder
        rootView.mailTextField.placeholder = textConfiguration.emailTextFieldPlaceholder
        rootView.passTextField.placeholder = textConfiguration.passwordTextFieldPlaceholder
        rootView.signInButton.firstText = textConfiguration.alreadyHaveAccountButtonTitle
        rootView.signInButton.secondText = textConfiguration.signInButtonTitle
        rootView.signUpButton.setTitle(textConfiguration.signUpButtonTitle, for: .normal)
        rootView.signUpWithAppleButton.setTitle(textConfiguration.signUpWithAppleButtonTitle, for: .normal)
                                                
    }
}
