// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.
import UIKit

class TitleLabel: UIStackView {
    // MARK: - UI Properties
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 34, weight: .black)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    // MARK: - Properties
    var gradientColors: [UIColor] {
        didSet {
            applyGradient()
        }
    }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var numberOfLines: Int {
        get { label.numberOfLines }
        set { label.numberOfLines = newValue }
    }

    var font: UIFont? {
        get { label.font }
        set { label.font = newValue }
    }

    // MARK: - Initializers
    init(gradientColors: [UIColor] = []) {
        self.gradientColors = gradientColors
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
    }

    // MARK: - Private Methods
    private func setupView() {
        axis = .vertical
        alignment = .center
        addArrangedSubview(label)
    }

    private func applyGradient() {
        let gradient = UIImage.gradientImage(
            bounds: .init(
                origin: label.bounds.origin,
                size: .init(width: label.bounds.width + 5, height: label.bounds.height)
            ),
            colors: gradientColors
        )
        label.textColor = UIColor(patternImage: gradient)
    }
}
