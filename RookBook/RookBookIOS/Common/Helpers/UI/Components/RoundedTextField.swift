// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

final class RoundedTextField: UITextField {
    // MARK: - Nested Types
    enum PlaceholderPosition {
        case top
        case inline
    }

    // MARK: - UI Properties
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime

        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private var placeholderLeadingConstraint: NSLayoutConstraint?
    private var placeholderCenterYConstraint: NSLayoutConstraint?
    private var placeholderTopConstraint: NSLayoutConstraint?

    // MARK: - Properties
    var onBeginEditing: (() -> Void)?
    var onEndEditing: (() -> Void)?
    var onInvalidDate: (() -> Void)?

    var isDateField: Bool = false
    private var placeholderPosition: PlaceholderPosition = .inline
    override var text: String? {
        didSet {
            if let text, !text.isEmpty, placeholderPosition == .inline {
                movePlaceholder(to: .top, animated: false)
            }
        }
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter
    }()

    var placeholderColor: UIColor = .green4 {
        didSet {
            updatePlaceholderText(placeholder)
            if let rightButton = rightView as? UIButton {
                rightButton.setImage(rightButton.imageView?.image?.withTintColor(placeholderColor), for: .normal)
            }
        }
    }

    private var placeholderFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)

    override var placeholder: String? {
        didSet { updatePlaceholderText(placeholder) }
    }

    override var delegate: UITextFieldDelegate? {
        get { super.delegate }
        set { super.delegate = self }
    }

    var borderColor: UIColor = .green4 { didSet { layer.borderColor = borderColor.cgColor } }

    // MARK: - Initializers
    init(isSecure: Bool = false, isDateField: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.borderColor = borderColor.cgColor
        isSecureTextEntry = isSecure
        setupRightButton(isSecure: isSecure)
        setupPlaceholderLabel()
        delegate = self
        self.isDateField = isDateField

        if isDateField {
            setupDatePicker()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let paddingX = bounds.width / 7
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: paddingX))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(
            top: bounds.height / 3,
            left: bounds.width,
            bottom: bounds.height / 3,
            right: bounds.width / 6
        ))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLeadingConstraint?.constant = 16
    }

    // MARK: - Private Methods
    private func setupDatePicker() {
        inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        ], animated: false)

        inputAccessoryView = toolbar
    }

    @objc private func dateChanged() {
        text = dateFormatter.string(from: datePicker.date)
        movePlaceholder(to: .top, animated: true)
    }

    @objc private func doneButtonTapped() {
        resignFirstResponder()
        onEndEditing?()
    }

    private func setupRightButton(isSecure: Bool) {
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(getEyeImage(isSecure: isSecure), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightViewMode = .always
        rightView = rightButton
        rightButton.addTarget(self, action: #selector(toggleSecureTextEntry), for: .touchUpInside)
        rightButton.isHidden = !isSecure
    }

    private func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        placeholderLeadingConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        placeholderCenterYConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        placeholderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2)
        placeholderLeadingConstraint?.isActive = true
        placeholderCenterYConstraint?.isActive = true
        placeholderTopConstraint?.isActive = false
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = placeholderFont
    }

    private func movePlaceholder(to position: PlaceholderPosition, animated: Bool = true) {
        placeholderPosition = position
        switch position {
        case .top:
            movePlaceholderToTop(animated: animated)
        case .inline:
            movePlaceholderToInline(animated: animated)
        }
    }

    private func movePlaceholderToTop(animated: Bool) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: UIColor.clear, .font: placeholderFont]
        )
        placeholderLabel.isHidden = false

        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.setTopPlaceholderConstraint()
            }
        } else {
            setTopPlaceholderConstraint()
        }
    }

    private func movePlaceholderToInline(animated: Bool) {
        attributedPlaceholder = NSAttributedString(string: "")
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.setCenterPlaceholderConstraint()
            }
        } else {
            setCenterPlaceholderConstraint()
        }
    }

    private func setTopPlaceholderConstraint() {
        placeholderTopConstraint?.isActive = true
        placeholderCenterYConstraint?.isActive = false
        layoutIfNeeded()
    }

    private func setCenterPlaceholderConstraint() {
        placeholderTopConstraint?.isActive = false
        placeholderCenterYConstraint?.isActive = true
        layoutIfNeeded()
    }

    private func activatePlaceholderAndBorder() {
        placeholderLeadingConstraint?.constant = bounds.width / 8

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.layer.borderWidth = 2
            self?.movePlaceholder(to: .top)
        }
    }

    private func deactivatePlaceholderAndBorder() {
        placeholderLeadingConstraint?.constant = bounds.width / 8

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.layer.borderWidth = 0
            if self?.text?.isEmpty == true {
                self?.movePlaceholder(to: .inline)
            }
        }
    }

    @objc private func toggleSecureTextEntry() {
        guard let rightButton = rightView as? UIButton else { return }
        isSecureTextEntry.toggle()
        animateRightButton(rightButton)
    }

    private func animateRightButton(_ button: UIButton) {
        button.alpha = 0.3
        UIView.animate(withDuration: 0.2) {
            button.alpha = 1.0
            button.setImage(self.getEyeImage(isSecure: self.isSecureTextEntry), for: .normal)
        }
    }

    private func getEyeImage(isSecure: Bool) -> UIImage? {
        UIImage(systemName: isSecure ? "eye.slash.circle" : "eye.circle")?
            .withTintColor(placeholderColor, renderingMode: .alwaysOriginal)
    }

    private func updatePlaceholderText(_ placeholder: String?) {
        guard let placeholder else { return }
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor, .font: placeholderFont]
        )
    }

    private func validateDateText() {
        guard let text, !text.isEmpty else { return }

        if dateFormatter.date(from: text) == nil {
            self.text = ""
            onInvalidDate?()
        }
    }
}

// MARK: - UITextFieldDelegate
extension RoundedTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activatePlaceholderAndBorder()
        onBeginEditing?()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        deactivatePlaceholderAndBorder()
        if isDateField {
            validateDateText()
        }

        onEndEditing?()
    }
}
