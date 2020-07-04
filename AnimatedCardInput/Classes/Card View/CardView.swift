//
//  CardView.swift
//  AnimatedCardInput
//

import UIKit

/// View acting as a container for front and back side of the Credit Card.
public final class CardView: UIView {

    // MARK: Hierarchy

    /// Height constraint that allows to keep Credit Card view in standard aspect.
    private lazy var heightConstraint: NSLayoutConstraint = {
        let constraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: 53.98 / 85.60)
        constraint.priority = .required
        return constraint
    }()

    /// Container for front side of Credit Card.
    private lazy var cardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Container for front side of Credit Card.
    private lazy var frontSideContainer: CardFrontSideView = {
        let view = CardFrontSideView(
            cardNumberDigitsLimit: cardNumberDigitsLimit,
            cardNumberChunkLengths: cardNumberChunkLengths
        )
        view.inputDelegate = self
        return view
    }()

    /// Container for back side of Credit Card.
    private lazy var backSideContainer: CardBackSideView = {
        let view = CardBackSideView(
            CVVNumberDigitsLimit: CVVNumberDigitsLimit
        )
        view.inputDelegate = self
        return view
    }()

    /// View that transition to currently selected Text Field.
    private lazy var selectionIndicator: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.cornerRadius = 8
        return view
    }()

    /// Handles taps outside of Text Fields to finish editing.
    private let tapGestureRecognizer = UITapGestureRecognizer()

    // MARK: Properties

    /// - seeAlso: CreditCardDataDelegate
    public weak var creditCardDataDelegate: CreditCardDataDelegate?

    /// Card Provider for current input of Card Number.
    private var currentCardProvider: CardProvider? {
        willSet {
            cardProviderImage = newValue?.icon
        }
    }

    private var shouldTextFieldsBecomeFirstResponder: Bool = true

    /// Indicates which Text Field is currently selected.
    public var currentInput: TextFieldType = .cardNumber {
        didSet {
            if shouldTextFieldsBecomeFirstResponder {
                switch currentInput {
                    case .cardNumber:
                        frontSideContainer.cardNumberField.becomeFirstResponder()
                    case .cardholderName:
                        frontSideContainer.cardholderNameField.becomeFirstResponder()
                    case .validityDate:
                        frontSideContainer.validityDateField.becomeFirstResponder()
                    case .CVVNumber:
                        backSideContainer.CVVNumberField.becomeFirstResponder()
                    case .none:
                        break
                }
            }
            if (currentInput != oldValue) && (currentInput == .CVVNumber && backSideContainer.isHidden) || (currentInput != .CVVNumber && frontSideContainer.isHidden) {
                flip()
            } else {
                updateIndicator(animated: true)
            }
        }
    }

    // MARK: Configurable properties

    /// Indicates if CVV Number should be masked.
    public var isSecureInput: Bool = false {
        willSet {
            backSideContainer.CVVNumberField.isSecureMode = newValue
        }
    }

    /// Indicates if Validity Date input is validated when retrieving data.
    public var validatesDateInput: Bool = true {
        willSet {
            frontSideContainer.validityDateField.validatesDateInput = newValue
        }
    }

    /// Image for the current card's provider.
    public var cardProviderImage: UIImage? {
        get { frontSideContainer.cardProviderImage }
        set(image) {
            frontSideContainer.cardProviderImage = image
            backSideContainer.cardProviderImage = image
        }
    }

    /// Background color of the card's front side - defaults to #373737.
    public var frontSideCardColor: UIColor? {
        get { frontSideContainer.backgroundColor }
        set(color) { frontSideContainer.backgroundColor = color }
    }

    /// Text color of the card's front side - defaults to #FFFFFF.
    public var frontSideTextColor: UIColor? {
        get { frontSideContainer.textColor }
        set(color) { frontSideContainer.textColor = color }
    }

    /// Background color of the card's back side - defaults to #373737.
    public var backSideCardColor: UIColor? {
        get { backSideContainer.backgroundColor }
        set(color) { backSideContainer.backgroundColor = color }
    }

    /// Background color of the card's CVV Field - defaults to #FFFFFF.
    public var CVVBackgroundColor: UIColor? {
        get { backSideContainer.CVVNumberField.backgroundColor }
        set(color) { backSideContainer.CVVNumberField.backgroundColor = color }
    }

    /// Text color of the card's back side - defaults to #000000.
    public var backSideTextColor: UIColor? {
        get { backSideContainer.textColor }
        set(color) { backSideContainer.textColor = color }
    }

    /// Border color of a selected field indicator - defaults to #ff8000.
    public var selectionIndicatorColor: UIColor? {
        get { UIColor(cgColor: selectionIndicator.layer.borderColor ?? UIColor.clear.cgColor) }
        set(color) { selectionIndicator.layer.borderColor = color?.cgColor }
    }

    /// Font of the Card Number Field - defaults to System SemiBold 24.
    public var numberInputFont: UIFont? {
        get { frontSideContainer.cardNumberField.font }
        set(font) { frontSideContainer.cardNumberField.font = font }
    }

    /// Font of the Cardholder Name Label - defaults to System Light 14.
    /// Recommended font size is 0.6 of Card Number size.
    public var nameLabelFont: UIFont? {
        get { frontSideContainer.cardholderNameLabel.font }
        set(font) { frontSideContainer.cardholderNameLabel.font = font }
    }

    /// Font of the Cardholder Name Field - defaults to System Regular 14.
    /// Recommended font size is 0.6 of Card Number size.
    public var nameInputFont: UIFont? {
        get { frontSideContainer.cardholderNameField.font }
        set(font) { frontSideContainer.cardholderNameField.font = font }
    }

    /// Font of the Validity Date Label - defaults to System Light 14.
    /// Recommended font size is 0.6 of Card Number size.
    public var validityLabelFont: UIFont? {
        get { frontSideContainer.cardholderNameLabel.font }
        set(font) { frontSideContainer.cardholderNameLabel.font = font }
    }

    /// Font of the Validity Date Field - defaults to System Regular 14.
    /// Recommended font size is 0.6 of Card Number size.
    public var validityInputFont: UIFont? {
        get { frontSideContainer.validityDateField.font }
        set(font) { frontSideContainer.validityDateField.font = font }
    }

    /// Font of the CVV Number Field - defaults to System SemiBold 20.
    /// Recommended font size is 0.85 of Card Number size.
    public var CVVInputFont: UIFont? {
        get { backSideContainer.CVVNumberField.font }
        set(font) { backSideContainer.CVVNumberField.font = font }
    }

    /// Character used as the Card Number Separator - defaults to " ".
    public var cardNumberSeparator: String {
        get { frontSideContainer.cardNumberField.separator }
        set(separator) { frontSideContainer.cardNumberField.separator = separator }
    }

    /// Character used as the Card Number Empty Character - defaults to "X".
    public var cardNumberEmptyCharacter: String {
        get { frontSideContainer.cardNumberField.emptyCharacter }
        set(emptyCharacter) { frontSideContainer.cardNumberField.emptyCharacter = emptyCharacter }
    }

    /// Character used as the Validity Date Separator - defaults to "/".
    public var validityDateSeparator: String {
        get { frontSideContainer.validityDateField.separator }
        set(separator) { frontSideContainer.validityDateField.separator = separator }
    }

    /// Text used as the Validity Date Placeholder - defaults to "MM/YY".
    public var validityDateCustomPlaceHolder: String {
        get { frontSideContainer.validityDateField.emptyCharacter }
        set(customPlaceholder) { frontSideContainer.validityDateField.customPlaceholder = customPlaceholder }
    }

    /// Character used as CVV Number Empty Character - defaults to "X".
    public var CVVNumberEmptyCharacter: String {
        get { backSideContainer.CVVNumberField.emptyCharacter }
        set(emptyCharacter) { backSideContainer.CVVNumberField.emptyCharacter = emptyCharacter }
    }

    /// Custom string for title label of Cardholder Name input.
    public var cardholderNameTitle: String? {
        get { frontSideContainer.cardholderNameLabel.text  }
        set(text) { frontSideContainer.cardholderNameLabel.text = text }
    }

    /// Custom string for placeholder of Cardholder Name input.
    public var cardholderNamePlaceholder: String? {
        get { frontSideContainer.cardholderNameField.placeholder }
        set(text) { frontSideContainer.cardholderNameField.placeholder = text }
    }

    /// Custom string for title label of Validity Date input.
    public var validityDateTitle: String? {
        get { frontSideContainer.validityDateLabel.text }
        set(text) { frontSideContainer.validityDateLabel.text = text }
    }

    /// Indicates maximum length of Card Number Text Field.
    private let cardNumberDigitsLimit: Int

    /// Indicates format of card number, e.g. [4, 3] means that number of length 7 will be split
    /// into two parts of length 4 and 3 respectively (XXXX XXX). Defaults to [4, 4, 4, 4].
    private let cardNumberChunkLengths: [Int]

    /// Indicates maximum length of CVV Number Text Field. Defaults to 3.
    private let CVVNumberDigitsLimit: Int

    // MARK: Initializers

    /// Initializes Card View.
    /// - Parameters:
    ///     - cardNumberDigitsLimit: Indicates maximum length of card number. Defaults to 16.
    ///     - cardNumberChunkLengths: Indicates format of card number,
    ///                               e.g. [4, 3] means that number of length 7 will be split
    ///                               into two parts of length 4 and 3 respectively (XXXX XXX).
    ///     - CVVNumberDigitsLimit: Indicates maximum length of CVV number. Defaults to 3.
    public init(
        cardNumberDigitsLimit: Int = 16,
        cardNumberChunkLengths: [Int] = [4, 4, 4, 4],
        CVVNumberDigitsLimit: Int = 3
    ) {
        self.cardNumberDigitsLimit = cardNumberDigitsLimit
        self.cardNumberChunkLengths = cardNumberChunkLengths
        self.CVVNumberDigitsLimit = CVVNumberDigitsLimit

        super.init(frame: .zero)

        setupViewHierarchy()
        setupLayoutConstraints()
        setupProperties()
        setupTextFieldBindings()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setupViewHierarchy() {
        [
            backSideContainer,
            frontSideContainer,
        ].forEach(addSubview)

        frontSideContainer.insertSubview(selectionIndicator, at: 0)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            heightConstraint,

            frontSideContainer.topAnchor.constraint(equalTo: topAnchor),
            frontSideContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            frontSideContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            frontSideContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            backSideContainer.topAnchor.constraint(equalTo: topAnchor),
            backSideContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            backSideContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            backSideContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setupProperties() {
        tapGestureRecognizer.addTarget(self, action: #selector(finishEditing))
        addGestureRecognizer(tapGestureRecognizer)

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }

    private func setupTextFieldBindings() {
        frontSideContainer.cardNumberField.addTarget(self, action: #selector(cardNumberEditingChanged), for: .editingChanged)
        frontSideContainer.cardholderNameField.addTarget(self, action: #selector(cardholderNameEditingChanged), for: .editingChanged)
        frontSideContainer.validityDateField.addTarget(self, action: #selector(validityDateEditingChanged), for: .editingChanged)
        backSideContainer.CVVNumberField.addTarget(self, action: #selector(CVVNumberEditingChanged), for: .editingChanged)
        frontSideContainer.cardNumberField.addTarget(self, action: #selector(cardNumberEditingBegan), for: .editingDidBegin)
        frontSideContainer.cardholderNameField.addTarget(self, action: #selector(cardholderNameEditingBegan), for: .editingDidBegin)
        frontSideContainer.validityDateField.addTarget(self, action: #selector(validityDateEditingBegan), for: .editingDidBegin)
        backSideContainer.CVVNumberField.addTarget(self, action: #selector(CVVNumberEditingBegan), for: .editingDidBegin)
    }

    // MARK: Private

    /// Performs aniamted rotation of Credit Card to show opposite side.
    /// - Parameters:
    ///     - duration: Indicates how long should be the animation.
    private func flip(with duration: Double = 0.5) {

        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration / 2, delay: 0, options: .curveLinear, animations: {
            transform = CATransform3DRotate(transform, (self.backSideContainer.isHidden ? 1 : -1) * CGFloat.pi / 2, 0, self.backSideContainer.isHidden ? 1 : -1, 0)
            self.layer.transform = transform
        }, completion: { _ in
            self.frontSideContainer.isHidden.toggle()
            self.backSideContainer.isHidden.toggle()

            if self.frontSideContainer.isHidden {
                self.backSideContainer.insertSubview(self.selectionIndicator, belowSubview: self.backSideContainer.CVVNumberField)
            } else {
                self.frontSideContainer.insertSubview(self.selectionIndicator, at: 0)
            }
            self.updateIndicator(animated: false)

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration / 2, delay: 0, options: .curveLinear, animations: {
                transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, self.backSideContainer.isHidden ? -1 : 1, 0)
                self.layer.transform = transform
            })
        })
    }

    // MARK: Text Field Bindings

    @objc private func cardNumberEditingChanged() {
        guard let newValue = frontSideContainer.cardNumberField.text else { return }
        creditCardDataDelegate?.cardNumberChanged(newValue)
    }

    @objc private func cardholderNameEditingChanged() {
        guard let newValue = frontSideContainer.cardholderNameField.text else { return }
        creditCardDataDelegate?.cardholderNameChanged(newValue)
    }

    @objc private func validityDateEditingChanged() {
        guard let newValue = frontSideContainer.validityDateField.text else { return }
        creditCardDataDelegate?.validityDateChanged(newValue)
    }

    @objc private func CVVNumberEditingChanged() {
        guard let newValue = backSideContainer.CVVNumberField.text else { return }
        creditCardDataDelegate?.CVVNumberChanged(newValue)
    }

    @objc private func cardNumberEditingBegan() {
        shouldTextFieldsBecomeFirstResponder = true
        creditCardDataDelegate?.beganEditing(in: .cardNumber)
    }

    @objc private func cardholderNameEditingBegan() {
        shouldTextFieldsBecomeFirstResponder = true
        creditCardDataDelegate?.beganEditing(in: .cardholderName)
    }

    @objc private func validityDateEditingBegan() {
        shouldTextFieldsBecomeFirstResponder = true
        creditCardDataDelegate?.beganEditing(in: .validityDate)
    }

    @objc private func CVVNumberEditingBegan() {
        shouldTextFieldsBecomeFirstResponder = true
        creditCardDataDelegate?.beganEditing(in: .CVVNumber)
    }
}

// MARK: CardViewInputDelegate

extension CardView: CardViewInputDelegate {

    /// Updates frame of selection indicator to current Text Field.
    /// - Parameters:
    ///     - animated: Indicates if update should be animated.
    func updateIndicator(animated: Bool) {
        selectionIndicator.isHidden = false
        let newFrame: CGRect = {
            switch currentInput {
                case .cardNumber:
                    return frontSideContainer.cardNumberField.frame
                case .cardholderName:
                    return frontSideContainer.cardholderNameField.frame
                case .validityDate:
                    return frontSideContainer.validityDateField.frame
                case .CVVNumber:
                    return backSideContainer.CVVNumberField.frame
                case .none:
                    return .zero
            }
        }()
        if selectionIndicator.frame == CGRect.zero.insetBy(dx: -8, dy: -4) {
            selectionIndicator.frame = CGRect(x: newFrame.minX, y: newFrame.minY, width: 5, height: newFrame.height)
        }
        if animated && currentInput != .none {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.selectionIndicator.frame = newFrame.insetBy(dx: -8, dy: -4)
            })
        } else {
            selectionIndicator.frame = newFrame.insetBy(dx: -8, dy: -4)
        }
    }

    /// Updates current selection to given type.
    /// - Parameters:
    ///     - type: TextFieldType value for selected Text Field.
    public func updateCurrentInput(to type: TextFieldType) {
        guard type != currentInput else { return }
        currentInput = type
    }

    /// Changes current selection to next Text Field in flow if possible.
    public func moveToNextTextField() {
        guard let nextInput = TextFieldType(rawValue: currentInput.rawValue + 1) else { return }
        updateCurrentInput(to: nextInput)
    }

    /// Changes current selection to previous Text Field in flow if possible.
    public func moveToPreviousTextField() {
        guard let prevInput = TextFieldType(rawValue: currentInput.rawValue - 1) else { return }
        updateCurrentInput(to: prevInput)
    }

    /// Finished editing by hiding keyboard and selection idnicator.
    @objc public func finishEditing() {
        endEditing(true)
        selectionIndicator.frame = .zero
        selectionIndicator.isHidden = true
        currentInput = .none
        creditCardDataDelegate?.beganEditing(in: .cardNumber)
    }

    /// Updates Card Provider icon based on Card number input.
    /// - Parameters:
    ///     - cardNumber: Card number for provider recognition.
    public func updateCardProvider(cardNumber: String) {
        currentCardProvider = CardProvider.recognizeProvider(from: cardNumber)
    }

    public func updateSelectionIndicator() {
        updateIndicator(animated: true)
    }
}

// MARK: CreditCardDataDelegate

extension CardView: CreditCardDataDelegate {

    /// - SeeAlso: CreditCardDataDelegate.beganEditing(textFieldType:)
    public func beganEditing(in textFieldType: TextFieldType) {
        shouldTextFieldsBecomeFirstResponder = false
        currentInput = textFieldType
    }

    /// - SeeAlso: CreditCardDataDelegate.cardNumberChanged(number:)
    public func cardNumberChanged(_ number: String) {
        frontSideContainer.cardNumberField.inputHasChanged(to: number)
        updateCardProvider(cardNumber: number)
    }

    /// - SeeAlso: CreditCardDataDelegate.cardholderNameChanged(name:)
    public func cardholderNameChanged(_ name: String) {
        frontSideContainer.cardholderNameField.text = name
        frontSideContainer.cardholderNameField.sendActions(for: .editingChanged)
    }

    /// - SeeAlso: CreditCardDataDelegate.validityDateChanged(date:)
    public func validityDateChanged(_ date: String) {
        frontSideContainer.validityDateField.inputHasChanged(to: date)
    }

    /// - SeeAlso: CreditCardDataDelegate.CVVNumberChanged(cvv:)
    public func CVVNumberChanged(_ cvv: String) {
        backSideContainer.CVVNumberField.inputHasChanged(to: cvv)
    }
}

// MARK: CreditCardDataProvider

extension CardView: CreditCardDataProvider {

    /// - SeeAlso: CreditCardDataProvider.creditCardData
    public var creditCardData: CreditCardData {
        guard
            let cardNumber = frontSideContainer.cardNumberField.text,
            let cardholderName = frontSideContainer.cardholderNameField.text,
            var validityDate = frontSideContainer.validityDateField.text,
            let CVVNumber = backSideContainer.CVVNumberField.text
        else {
            return CreditCardData()
        }
        if validityDate.count > 2 {
            validityDate.insert(contentsOf: validityDateSeparator, at: validityDate.index(validityDate.startIndex, offsetBy: 2))
        }
        return CreditCardData(
            cardProvider: currentCardProvider,
            cardNumber: cardNumber,
            cardholderName: cardholderName,
            validityDate: validityDate,
            CVVNumber: CVVNumber
        )
    }
}
