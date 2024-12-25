// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

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
