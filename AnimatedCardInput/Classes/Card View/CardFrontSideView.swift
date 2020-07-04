//
//  CardFrontSideView.swift
//  AnimatedCardInput
//

import UIKit

/// View representing front side of a Credit Card.
final class CardFrontSideView: CardSideView {

    // MARK: Hierarchy

    /// Text Field for Card Number input.
    internal lazy var cardNumberField: CustomInputField = {
        let textField = CustomInputField(
            digitsLimit: cardNumberDigitsLimit,
            chunkLengths: cardNumberChunkLengths
        )
        textField.separator = " "
        textField.emptyCharacter = "X"
        textField.font = .systemFont(ofSize: 24)
        textField.keyboardType = .decimalPad

        let prevButton = previousToolbarButton
        prevButton.isEnabled = false
        textField.inputAccessoryView = {
            let toolbar = UIToolbar()
            toolbar.items = [finishToolbarButton, spacingToolbarItem, prevButton, nextToolbarButton]
            toolbar.sizeToFit()
            return toolbar
        }()
        return textField
    }()

    /// Label with description of Cardholder Name field.
    internal lazy var cardholderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cardholder Name".uppercased()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()

    /// Text Field for Cordholder Name input.
    internal lazy var cardholderNameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Name Surname".uppercased(),
            attributes: [
                .foregroundColor: textColor?.withAlphaComponent(0.6) ?? .clear,
                .font: UIFont.systemFont(ofSize: 14),
            ]
        )
        textField.tintColor = .clear
        textField.autocorrectionType = .no
        textField.inputAccessoryView = {
            let toolbar = UIToolbar()
            toolbar.items = [finishToolbarButton, spacingToolbarItem, previousToolbarButton, nextToolbarButton]
            toolbar.sizeToFit()
            return toolbar
        }()
        return textField
    }()

    /// Label with description of Validity Date Field.
    internal lazy var validityDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Valid Thru".uppercased()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .right
        return label
    }()

    /// Text Field for Validity Date input.
    internal lazy var validityDateField: CustomInputField = {
        let textField = CustomInputField(
            digitsLimit: 4,
            chunkLengths: [2, 2]
        )
        textField.validatesDateInput = true
        textField.separator = "/"
        textField.customPlaceholder = "MM/YY"
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .decimalPad
        textField.inputAccessoryView = {
            let toolbar = UIToolbar()
            toolbar.items = [finishToolbarButton, spacingToolbarItem, previousToolbarButton, nextToolbarButton]
            toolbar.sizeToFit()
            return toolbar
        }()

        return textField
    }()

    // MARK: Properties

    /// Indicates maximum length of Card Number Text Field. Defaults to 16.
    private let cardNumberDigitsLimit: Int

    /// Indicates format of card number, e.g. [4, 3] means that number of length 7 will be split
    /// into two parts of length 4 and 3 respectively (XXXX XXX). Defaults to [4, 4, 4, 4].
    private let cardNumberChunkLengths: [Int]

    // MARK: Initializers

    /// Initializes Card Side View.
    /// - Parameters:
    ///     - cardNumberDigitsLimit: Indicates maximum length of card number. Defaults to 16.
    ///     - cardNumberChunkLengths: Indicates format of card number,
    ///                               e.g. [4, 3] means that number of length 7 will be split
    ///                               into two parts of length 4 and 3 respectively (XXXX XXX).
    /// - seeAlso: CardSideView.init()
    init(
        cardNumberDigitsLimit: Int = 16,
        cardNumberChunkLengths: [Int] = [4, 4, 4, 4]
    ) {
        self.cardNumberDigitsLimit = cardNumberDigitsLimit
        self.cardNumberChunkLengths = cardNumberChunkLengths
        super.init()

        setupViewHierarchy()
        setupLayoutConstraints()
        setupProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setupViewHierarchy() {
        [
            cardProviderView,
            cardNumberField,
            cardholderNameLabel,
            cardholderNameField,
            validityDateLabel,
            validityDateField,
        ].forEach(addSubview)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cardProviderView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            cardProviderView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            cardProviderView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            cardProviderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            cardNumberField.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardNumberField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardNumberField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            cardholderNameLabel.centerYAnchor.constraint(equalTo: validityDateLabel.centerYAnchor),
            cardholderNameLabel.leadingAnchor.constraint(equalTo: cardholderNameField.leadingAnchor),

            cardholderNameField.heightAnchor.constraint(equalTo: validityDateField.heightAnchor),
            cardholderNameField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            cardholderNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            validityDateLabel.bottomAnchor.constraint(equalTo: validityDateField.topAnchor, constant: -4),
            validityDateLabel.leadingAnchor.constraint(equalTo: cardholderNameLabel.trailingAnchor, constant: 16),
            validityDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            validityDateField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            validityDateField.centerYAnchor.constraint(equalTo: cardholderNameField.centerYAnchor),
            validityDateField.leadingAnchor.constraint(greaterThanOrEqualTo: cardholderNameField.trailingAnchor, constant: 32),
            validityDateField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    /// - seeAlso: CardSideView.setupProperties()
    internal override func setupProperties() {
        super.setupProperties()

        textColor = .white

        cardNumberField.addTarget(self, action: #selector(updateCardProvider), for: .editingChanged)
        cardholderNameField.addTarget(self, action: #selector(capitalizeNameField), for: .editingChanged)

        cardNumberField.addTarget(self, action: #selector(selectedNumberField), for: .editingDidBegin)
        cardholderNameField.addTarget(self, action: #selector(selectedNameField), for: .editingDidBegin)
        validityDateField.addTarget(self, action: #selector(selectedValidityField), for: .editingDidBegin)
    }

    /// - seeAlso: CardSideView.updateTextColor()
    internal override func updateTextColor() {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
        ].forEach {
            $0.textColor = textColor
        }

        [
            cardholderNameLabel,
            validityDateLabel,
        ].forEach {
            $0.textColor = textColor
        }

        cardholderNameField.attributedPlaceholder = NSAttributedString(
            string: (cardholderNameField.attributedPlaceholder?.string ?? "").uppercased(),
            attributes: [
                .foregroundColor: textColor?.withAlphaComponent(0.5) ?? .clear,
                .font: cardholderNameField.font ?? UIFont.systemFont(ofSize: 14),
            ]
        )
    }

    // MARK: Private

    /// Updates Cardholder Name Field input to uppercase.
    @objc private func capitalizeNameField() {
        cardholderNameField.text = cardholderNameField.text?.uppercased()
        cardholderNameField.sizeToFit()

        /// UITextField extends it's frame even when it is wrapping text inside,
        /// so we don't want to update indicator frame after reaching maximum width.
        guard validityDateField.frame.minX - cardholderNameField.frame.maxX >= 32 else { return }
        inputDelegate?.updateSelectionIndicator()
    }

    /// Updates Card Provider icon based on Card Number input.
    @objc private func updateCardProvider() {
        inputDelegate?.updateCardProvider(cardNumber: cardNumberField.text ?? "")
    }

    /// Updated current selection to Card Number Field.
    @objc private func selectedNumberField() {
        inputDelegate?.updateCurrentInput(to: .cardNumber)
    }

    /// Updated current selection to Cardholder Name Field.
    @objc private func selectedNameField() {
        inputDelegate?.updateCurrentInput(to: .cardholderName)
    }

    /// Updated current selection to Validity Date Field.
    @objc private func selectedValidityField() {
        inputDelegate?.updateCurrentInput(to: .validityDate)
    }
}
