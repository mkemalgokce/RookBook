// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class FooterButton: UIButton {
    // MARK: - Properties
    private let firstText: String
    private let secondText: String

    var firstColor: UIColor = .black {
        didSet {
            configureTexts()
        }
    }

    var secondColor: UIColor = .black {
        didSet {
            configureTexts()
        }
    }

    // MARK: - Initializers
    init(firstText: String, secondText: String) {
        self.firstText = firstText
        self.secondText = secondText
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        configureTexts()
    }

    private func configureTexts() {
        let attributedString = NSMutableAttributedString(strings: [
            .init(string: firstText,
                  attributes: [.foregroundColor:
                      firstColor,
                      .font: UIFont.preferredFont(
                          forTextStyle: .caption1
                      )]),
            .init(
                string: " " + secondText,
                attributes: [
                    .foregroundColor: secondColor,
                    .font: UIFont.preferredFont(forTextStyle: .caption1)
                ]
            )
        ])
        setAttributedTitle(
            attributedString,
            for: .normal
        )
    }
}
