//
//  CustomInputField.swift
//  AnimatedCardInput
//

import UIKit

/// Protocol handling change of Text Field Selection
protocol CustomInputSelectionDelegate: AnyObject {
    func updateCurrentFieldSelection(to textField: UITextField)
}

/// Custom Text Field used for displaying user input directly on Credit Card.
internal final class CustomInputField: UITextField {

    // MARK: Properties overrides

    /// Color of displayed text.
    override var textColor: UIColor? {
        willSet {
            (labelsStackView.arrangedSubviews as? [UILabel])?.forEach {
                $0.textColor = newValue
            }
        }
    }

    /// Font of displayed text.
    override var font: UIFont? {
        willSet {
            (labelsStackView.arrangedSubviews as? [UILabel])?.forEach {
                $0.font = newValue
            }
        }
    }

    // MARK: Properties

    /// - seeAlso: CustomInputSelectionDelegate
    weak var selectionDelegate: CustomInputSelectionDelegate?

    /// Indicates if input should be masked.
    internal var isSecureMode: Bool = false {
        didSet {
            updateLabels()
        }
    }

    /// Indicates if input should be checked for valid date value.
    internal var validatesDateInput: Bool = false {
        didSet {
            validateDate()
        }
    }

    /// Character used as input chunks separator.
    internal var separator: String = " " {
        didSet {
            updateLabels()
            if validatesDateInput {
                dateFormatter.dateFormat = "MM\(secureSeparator)YY"
            }
        }
    }

    /// Character used as input empty character.
    internal var emptyCharacter: String = "x" {
        didSet {
            updateLabels()
        }
    }

    /// Empty Character value that for sure is not a number and contains only one character.
    internal var safeEmptyCharacter: String {
        guard
            !emptyCharacter.isEmpty,
            emptyCharacter.count == 1,
            emptyCharacter.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil
        else { return "x" }
        return emptyCharacter
    }

    /// String used as custom placeholder instead of Empty Character.
    internal var customPlaceholder: String? {
        didSet {
            updateLabels()
        }
    }

    /// Separator value that for sure is not a number and contains only one character.
    private var secureSeparator: String {
        guard
            !separator.isEmpty,
            separator.count == 1,
            separator.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil
        else { return " " }
        return separator
    }

    /// Indicates maximum length of input.
    private let digitsLimit: Int

    /// Indicates format of card number, e.g. [4, 3] means that number of length 7 will be split
    /// into two parts of length 4 and 3 respectively (XXXX XXX).
    private let chunkLengths: [Int]

    private lazy var dateFormatter = DateFormatter()

    // MARK: Hierarchy

    /// Collection of Labels that displays current input.
    private var inputLabels: [UILabel] {
        labelsStackView.arrangedSubviews as? [CustomInputLabel] ?? []
    }

    /// Container for inputLabels that spaces them equally.
    private lazy var labelsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually

        for _ in 0..<(digitsLimit + max(1, chunkLengths.count) - 1) {
            view.addArrangedSubview(CustomInputLabel())
        }

        return view
    }()

    /// Taps handler for Text Field selection.
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return tapRecognizer
    }()

    // MARK: Initializers

    /// Initializes CustomInputField.
    /// - Parameters:
    ///     - digitsLimit: Indicates maximum length of tet field input. Defaults to 16.
    ///     - chunkLengths: Indicates format of text field input,
    ///                     e.g. [4, 3] means that number of length 7 will be split
    ///                     into two parts of length 4 and 3 respectively (XXXX XXX).
    init(
        digitsLimit: Int = 16,
        chunkLengths: [Int] = []
    ) {
        self.digitsLimit = digitsLimit

        let secureChunkLengths: [Int] = {
            guard !chunkLengths.isEmpty else { return [] }

            var secureChunkLengths: [Int] = chunkLengths
            while secureChunkLengths.reduce(0, +) > digitsLimit {
                secureChunkLengths = secureChunkLengths.dropLast()
            }

            for index in 1..<secureChunkLengths.count {
                secureChunkLengths[index] += secureChunkLengths[index - 1] + 1
            }
            return secureChunkLengths
        }()
        self.chunkLengths = secureChunkLengths

        super.init(frame: .zero)

        setupViewHierarchy()
        setupLayoutConstraints()
        setupProperties()
        updateLabels()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    internal func inputHasChanged(to value: String) {
        text = value
        updateLabels()
    }

    // MARK: Setup

    private func setupViewHierarchy() {
        addSubview(labelsStackView)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        tintColor = .clear
        textColor = .clear
        addGestureRecognizer(tapGestureRecognizer)
        subviews.forEach { $0.isHidden = true }
        labelsStackView.isHidden = false
    }

    private func setupBindings() {
        addTarget(self, action: #selector(updateLabels), for: .editingChanged)
        addTarget(self, action: #selector(validateDate), for: .editingDidEnd)
    }

    // MARK: Private

    /// Updates all inputLabels with current input.
    @objc private func updateLabels() {
        guard var text = self.text else { return }

        for chunkLength in chunkLengths {
            if chunkLength < text.count {
                text.insert(contentsOf: secureSeparator, at: text.index(text.startIndex, offsetBy: chunkLength))
            }
        }
        for (it, label) in inputLabels.enumerated() {
            let customCharacter: String = {
                if let customPlaceholder = customPlaceholder {
                    return String(it < customPlaceholder.count ? customPlaceholder[customPlaceholder.index(customPlaceholder.startIndex, offsetBy: it)] : " ")
                } else {
                    return chunkLengths.contains(it) ? secureSeparator : safeEmptyCharacter
                }
            }()
            label.text = it < text.count ? "\(isSecureMode ? "•" : text[text.index(text.startIndex, offsetBy: it)])" : customCharacter
            label.alpha = it < text.count ? 1 : 0.6
        }
    }

    @objc private func validateDate() {
        guard validatesDateInput, var input = text else { return }
        if input.count < 3 {
            text = ""
        } else {
            input.insert(contentsOf: secureSeparator, at: input.index(input.startIndex, offsetBy: 2))
            if dateFormatter.date(from: input) == nil {
                text = ""
            }
        }
        sendActions(for: .editingChanged)
    }
}

// MARK: UITextFieldDelegate

extension CustomInputField: UITextFieldDelegate {

    /// - seeAlso: UITextFieldDelegate.textField(_: shouldChangeCharactersIn:, replacementString)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
            let range = Range(range, in: currentText) else { return false }

        return currentText.replacingCharacters(in: range, with: string).count <= digitsLimit || digitsLimit == 0
    }
}

// MARK: DigitInputLabel

/// Label used for digit display in CustomInputField.
private final class CustomInputLabel: UILabel {

    // MARK: Initializers

    /// Initializes instance of CustomInputLabel
    init() {
        super.init(frame: .zero)

        setupProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private

    private func setupProperties() {
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 30)
        isUserInteractionEnabled = true
        layer.cornerRadius = 5
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
    }
}
