//
//  CardBackSideView.swift
//  AnimatedCardInput
//

import UIKit

/// View representing back side of a Credit Card.
final class CardBackSideView: CardSideView {

    // MARK: Hierarchy

    /// Text Field for CVV Number input.
    internal lazy var CVVNumberField: CustomInputField = {
        let textField = CustomInputField(digitsLimit: CVVNumberDigitsLimit)
        textField.emptyCharacter = "X"
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 20)

        let nextButton = nextToolbarButton
        nextButton.isEnabled = false
        textField.inputAccessoryView = {
            let toolbar = UIToolbar()
            toolbar.items = [finishToolbarButton, spacingToolbarItem, previousToolbarButton, nextButton]
            toolbar.sizeToFit()
            return toolbar
        }()
        return textField
    }()

    /// View imitating black bar at the back of Card.
    private lazy var blackBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    /// Container imitating view for owner signature at the back of Card.
    private lazy var signatureBarsBackgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        for i in 0..<4 {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = i % 2 == 0 ? .white : .gray
            stackView.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            ])
        }
        return stackView
    }()

    // MARK: Properties

    /// Indicates maximum length of CVV Number Text Field. Defaults to 3.
    private let CVVNumberDigitsLimit: Int

    // MARK: Initializers

    /// Initializes Card Side View.
    /// - Parameters:
    ///     - CVVNumberDigitsLimit: Indicates maximum length of CVV number. Defaults to 3.
    /// - seeAlso: CardSideView.init()
    init(CVVNumberDigitsLimit: Int = 3) {
        self.CVVNumberDigitsLimit = CVVNumberDigitsLimit
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
            blackBarView,
            signatureBarsBackgroundStackView,
            CVVNumberField,
            cardProviderView,
        ].forEach(addSubview)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            blackBarView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            blackBarView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            blackBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blackBarView.trailingAnchor.constraint(equalTo: trailingAnchor),

            signatureBarsBackgroundStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            signatureBarsBackgroundStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            signatureBarsBackgroundStackView.topAnchor.constraint(equalTo: blackBarView.bottomAnchor, constant: 24),
            signatureBarsBackgroundStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            CVVNumberField.heightAnchor.constraint(equalTo: signatureBarsBackgroundStackView.heightAnchor),
            CVVNumberField.widthAnchor.constraint(equalTo: signatureBarsBackgroundStackView.widthAnchor, multiplier: 0.3),
            CVVNumberField.leadingAnchor.constraint(equalTo: signatureBarsBackgroundStackView.trailingAnchor),
            CVVNumberField.centerYAnchor.constraint(equalTo: signatureBarsBackgroundStackView.centerYAnchor),

            cardProviderView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            cardProviderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            cardProviderView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            cardProviderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    /// - seeAlso: CardSideView.setupProperties()
    internal override func setupProperties() {
        super.setupProperties()

        isHidden = true
        transform = CGAffineTransform(scaleX: -1, y: 1)
        textColor = .black

        CVVNumberField.addTarget(self, action: #selector(selectedCVVField), for: .editingDidBegin)
    }

    /// - seeAlso: CardSideView.updateTextColor()
    internal override func updateTextColor() {
        CVVNumberField.textColor = textColor
    }

    // MARK: Private

    /// Updated current selection to CVV Number Field.
    @objc private func selectedCVVField() {
        inputDelegate?.updateCurrentInput(to: .CVVNumber)
    }
}
