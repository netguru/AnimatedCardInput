//
//  CardInputField.swift
//  AnimatedCardInput
//

import UIKit

/// View with title label and text field for input of credit card data.
public final class CardInputField: UIView {

    // MARK: Properties

    /// Indicates if input should be checked for valid date value.
    internal var validatesDateInput: Bool = false {
        didSet {
            validateDate()
        }
    }

    /// Indicates maximum length of input.
    private let inputLimit: Int

    /// Indictes if input should be formatted as date.
    private let isDateInput: Bool

    /// Character used as date value separator.
    private let dateSeparator: String

    /// Date formatter used to validate date input.
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM\(dateSeparator)YY"
        return formatter
    }()

    // MARK: Hierarchy

    /// Label with title for Input Field.
    internal lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()

    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .clear
        return view
    }()

    /// Input Field.
    internal lazy var inputField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()

    // MARK: Initializers

    /// Initializes CardInputField.
    /// - Parameters:
    ///     - title: Text to display as title above `Text Field`.
    ///     - inputLimit: Maximum number of characters for this input. Defaults to 0 (unlimited)
    ///     - isDateInput: Indictes if input should be formatted as date. Defaults to false.
    ///     - dateSeparator: Character used as date separator. Defaults to `/`
    init(
        title: String,
        inputLimit: Int = 0,
        isDateInput: Bool = false,
        dateSeparator: String = "/"
    ) {
        self.inputLimit = inputLimit
        self.isDateInput = isDateInput
        self.dateSeparator = dateSeparator
        super.init(frame: .zero)

        titleLabel.text = title

        setupViewHierarchy()
        setupLayoutConstraints()
        setupProperties()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITextFieldDelegate

    @discardableResult public override func becomeFirstResponder() -> Bool {
        inputField.becomeFirstResponder()
    }

    // MARK: Setup

    /// Setup Text Fields toolbar with custom buttons.
    /// - Parameters:
    ///     - finishToolbarButton: button for finishing the editing.
    ///     - previousToolbarButton: for returning to previous Text Field.
    ///     - nextToolbarButton: button for progressing to next Text Field.
    internal func setupTextFieldToolbar(
        finishToolbarButton: UIBarButtonItem,
        previousToolbarButton: UIBarButtonItem,
        nextToolbarButton: UIBarButtonItem
    ) {
        inputField.inputAccessoryView = {
            let toolbar = UIToolbar()
            toolbar.items = [
                finishToolbarButton,
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                previousToolbarButton,
                nextToolbarButton,
            ]
            toolbar.sizeToFit()
            return toolbar
        }()
    }

    private func setupViewHierarchy() {
        inputContainerView.addSubview(inputField)
        [
            titleLabel,
            inputContainerView,
        ].forEach(addSubview)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),

            inputContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            inputContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            inputContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            inputField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 6),
            inputField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -6),
            inputField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 6),
            inputField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -6),
        ])
    }

    private func setupProperties() {
        isUserInteractionEnabled = true
    }

    private func setupBindings() {
        inputField.addTarget(self, action: #selector(validateDate), for: .editingDidEnd)
    }

    // MARK: Private

    @objc private func validateDate() {
        guard
            validatesDateInput,
            let input = inputField.text,
            dateFormatter.date(from: input) == nil
        else {
            return
        }
        inputField.text = ""
        inputField.sendActions(for: .editingChanged)
    }
}

extension CardInputField: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if
            isDateInput,
            currentText.count == 2,
            currentText.count < updatedText.count
        {
            textField.text = currentText + dateSeparator
        }
        return inputLimit == 0 || updatedText.count <= inputLimit
    }
}
