//
//  CardInputsView.swift
//  AnimatedCardInput
//

import UIKit

/// Scroll View containing `Card Input Fields` for input of Credit Card information.
public class CardInputsView: UIScrollView {

    // MARK: Hierarchy

    /// Toolbar button for finishing the editing.
    internal var finishToolbarButton: UIBarButtonItem {
        UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishEditing))
    }

    /// Toolbar button for progressing to next Text Field.
    internal var nextToolbarButton: UIBarButtonItem {
        UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTextField))
    }

    /// Toolbar button for returning to previous Text Field.
    internal var previousToolbarButton: UIBarButtonItem {
        UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousTextField))
    }

    /// Container for Credit Card inputs.
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    internal lazy var cardNumberField: CardInputField = {
        let textField = CardInputField(title: "Card Number", inputLimit: cardNumberDigitLimit)
        textField.inputField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        let prevButton = self.previousToolbarButton
        prevButton.isEnabled = false
        textField.setupTextFieldToolbar(
            finishToolbarButton: self.finishToolbarButton,
            previousToolbarButton: prevButton,
            nextToolbarButton: self.nextToolbarButton
        )
        return textField
    }()

    internal lazy var cardholderNameField: CardInputField = {
        let textField = CardInputField(title: "Cardholder Name")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setupTextFieldToolbar(
            finishToolbarButton: self.finishToolbarButton,
            previousToolbarButton: self.previousToolbarButton,
            nextToolbarButton: self.nextToolbarButton
        )
        return textField
    }()

    internal lazy var validityDateField: CardInputField = {
        let textField = CardInputField(title: "Validity Date", inputLimit: 5, isDateInput: true)
        textField.validatesDateInput = true
        textField.inputField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setupTextFieldToolbar(
            finishToolbarButton: self.finishToolbarButton,
            previousToolbarButton: self.previousToolbarButton,
            nextToolbarButton: self.nextToolbarButton
        )
        return textField
    }()

    internal lazy var CVVNumberField: CardInputField = {
        let textField = CardInputField(title: "CVV Number", inputLimit: 3)
        textField.inputField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        let nextButton = self.nextToolbarButton
        nextButton.isEnabled = false
        textField.setupTextFieldToolbar(
            finishToolbarButton: self.finishToolbarButton,
            previousToolbarButton: self.previousToolbarButton,
            nextToolbarButton: nextButton
        )
        return textField
    }()

    // MARK: Properties

    /// - seeAlso: CardViewInputSelectionDelegate
    public weak var cardViewDelegate: CardViewInputDelegate?

    /// - seeAlso: CreditCardDataDelegate
    public weak var creditCardDataDelegate: CreditCardDataDelegate?

    /// Indicates if CVV Number should be masked.
    public var isSecureInput: Bool = false {
        willSet {
            CVVNumberField.inputField.isSecureTextEntry = newValue
        }
    }

    /// Indicates if Validity Date input is validated when retrieving data.
    public var validatesDateInput: Bool = true {
        willSet {
            validityDateField.validatesDateInput = newValue
        }
    }

    private let cardNumberDigitLimit: Int

    private let unfocusedFieldAlpha: CGFloat = 0.6

    private var shouldTextFieldsBecomeFirstResponder: Bool = true

    /// Card Provider for current input of Card Number.
    private var currentCardProvider: CardProvider?

    fileprivate var currentInput: TextFieldType = .cardNumber {
        didSet {
            switch currentInput {
                case .cardNumber:
                    cardNumberField.alpha = 1
                    cardholderNameField.alpha = unfocusedFieldAlpha
                    if shouldTextFieldsBecomeFirstResponder { cardNumberField.becomeFirstResponder() }
                case .cardholderName:
                    cardNumberField.alpha = unfocusedFieldAlpha
                    cardholderNameField.alpha = 1
                    validityDateField.alpha = unfocusedFieldAlpha
                    if shouldTextFieldsBecomeFirstResponder { cardholderNameField.becomeFirstResponder() }
                case .validityDate:
                    cardholderNameField.alpha = unfocusedFieldAlpha
                    validityDateField.alpha = 1
                    CVVNumberField.alpha = unfocusedFieldAlpha
                    if shouldTextFieldsBecomeFirstResponder { validityDateField.becomeFirstResponder() }
                case .CVVNumber:
                    validityDateField.alpha = unfocusedFieldAlpha
                    CVVNumberField.alpha = 1
                    if shouldTextFieldsBecomeFirstResponder { CVVNumberField.becomeFirstResponder() }
                case .none:
                    break
            }
        }
    }

    // MARK: Configurable properties

    /// Color of text in title label.
    public var titleColor: UIColor? {
        get { cardNumberField.titleLabel.textColor }
        set(color) { updateTitleColor(color) }
    }

    /// Font of text in title label.
    public var titleFont: UIFont? {
        get { cardNumberField.titleLabel.font }
        set(font) { updateTitleFont(font) }
    }

    /// Color of text in text field.
    public var inputColor: UIColor? {
        get { cardNumberField.inputField.textColor }
        set(color) { updateInputColor(color) }
    }

    /// Font of text in text field.
    public var inputFont: UIFont? {
        get { cardNumberField.inputField.font }
        set(font) { updateInputFont(font) }
    }

    /// Color of tint for text field.
    public var inputTintColor: UIColor? {
        get { cardNumberField.inputField.tintColor }
        set(color) { updateTintColor(color) }
    }

    /// Color of border for text field.
    public var inputBorderColor: CGColor? {
        get { cardNumberField.inputField.layer.borderColor }
        set(color) { updateBorderColor(color) }
    }

    /// Custom string for title label of Card Number input.
    public var cardNumberTitle: String? {
        get { cardNumberField.titleLabel.text }
        set(text) { cardNumberField.titleLabel.text = text }
    }

    /// Custom string for title label of Cardholder Name input.
    public var cardholderNameTitle: String? {
        get { cardholderNameField.titleLabel.text }
        set(text) { cardholderNameField.titleLabel.text = text }
    }

    /// Custom string for title label of Validity Date input.
    public var validityDateTitle: String? {
        get { validityDateField.titleLabel.text }
        set(text) { validityDateField.titleLabel.text = text }
    }

    /// Custom string for title label of CVV Number input.
    public var cvvNumberTitle: String? {
        get { CVVNumberField.titleLabel.text }
        set(text) { CVVNumberField.titleLabel.text = text }
    }

    /// Character used as the Validity Date Separator - defaults to "/".
    public var validityDateSeparator: String = "/"

    // MARK: Initializers

    /// Initializes CardInputsView.
    /// Properties:
    ///     - cardNumberDigitLimit: Limit of digits in credit card's number. Defaults to 16.
    public init(
        cardNumberDigitLimit: Int = 16
    ) {
        self.cardNumberDigitLimit = cardNumberDigitLimit
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
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach(stackView.addArrangedSubview)

        addSubview(stackView)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalTo: widthAnchor),
                $0.topAnchor.constraint(equalTo: stackView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            ])
        }
    }

    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        delegate = self
        clipsToBounds = false
    }

    private func setupTextFieldBindings() {
        cardNumberField.inputField.addTarget(self, action: #selector(cardNumberEditingChanged), for: .editingChanged)
        cardholderNameField.inputField.addTarget(self, action: #selector(cardholderNameEditingChanged), for: .editingChanged)
        validityDateField.inputField.addTarget(self, action: #selector(validityDateEditingChanged), for: .editingChanged)
        CVVNumberField.inputField.addTarget(self, action: #selector(CVVNumberEditingChanged), for: .editingChanged)

        cardNumberField.inputField.addTarget(self, action: #selector(cardNumberEditingBegan), for: .editingDidBegin)
        cardholderNameField.inputField.addTarget(self, action: #selector(cardholderNameEditingBegan), for: .editingDidBegin)
        validityDateField.inputField.addTarget(self, action: #selector(validityDateEditingBegan), for: .editingDidBegin)
        CVVNumberField.inputField.addTarget(self, action: #selector(CVVNumberEditingBegan), for: .editingDidBegin)
    }

    // MARK: Private

    private func updateTitleColor(_ color: UIColor?) {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach { $0.titleLabel.textColor = color }
    }

    private func updateTitleFont(_ font: UIFont?) {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach { $0.titleLabel.font = font }
    }

    private func updateInputColor(_ color: UIColor?) {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach { $0.inputField.textColor = color }
    }

    private func updateInputFont(_ font: UIFont?) {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach { $0.inputField.font = font }
    }

    private func updateTintColor(_ color: UIColor?) {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach { $0.inputField.tintColor = color }
    }

    private func updateBorderColor(_ color: CGColor?) {
        [
            cardNumberField,
            cardholderNameField,
            validityDateField,
            CVVNumberField,
        ].forEach { $0.inputField.layer.borderColor = color }
    }

    private func updateCurrentInput(to type: TextFieldType) {
        guard type != currentInput else { return }
        currentInput = type
    }

    /// Informs Selection Delegate to progress to next Text Field.
    @objc private func nextTextField() {
        guard let nextInput = TextFieldType(rawValue: currentInput.rawValue + 1) else { return }
        updateCurrentInput(to: nextInput)
    }

    /// Informs Selection Delegate to return to previous Text Field.
    @objc private func previousTextField() {
        guard let prevInput = TextFieldType(rawValue: currentInput.rawValue - 1) else { return }
        updateCurrentInput(to: prevInput)
    }

    /// Informs Selection Delegate to finish editing.
    @objc internal func finishEditing() {
        endEditing(true)
        currentInput = .none
    }

    // MARK: Text Field Bindings

    @objc private func cardNumberEditingChanged() {
        guard let newValue = cardNumberField.inputField.text else { return }
        creditCardDataDelegate?.cardNumberChanged(newValue)
        currentCardProvider = CardProvider.recognizeProvider(from: newValue)
    }

    @objc private func cardholderNameEditingChanged() {
        guard let newValue = cardholderNameField.inputField.text else { return }
        creditCardDataDelegate?.cardholderNameChanged(newValue)
    }

    @objc private func validityDateEditingChanged() {
        guard let newValue = validityDateField.inputField.text else { return }
        creditCardDataDelegate?.validityDateChanged(newValue.replacingOccurrences(of: validityDateSeparator, with: ""))
    }

    @objc private func CVVNumberEditingChanged() {
        guard let newValue = CVVNumberField.inputField.text else { return }
        creditCardDataDelegate?.CVVNumberChanged(newValue)
    }

    @objc private func cardNumberEditingBegan() {
        currentInput = .cardNumber
        creditCardDataDelegate?.beganEditing(in: .cardNumber)
    }

    @objc private func cardholderNameEditingBegan() {
        currentInput = .cardholderName
        creditCardDataDelegate?.beganEditing(in: .cardholderName)
    }

    @objc private func validityDateEditingBegan() {
        currentInput = .validityDate
        creditCardDataDelegate?.beganEditing(in: .validityDate)
    }

    @objc private func CVVNumberEditingBegan() {
        currentInput = .CVVNumber
        creditCardDataDelegate?.beganEditing(in: .CVVNumber)
    }
}

// MARK: UIScrollViewDelegate

extension CardInputsView: UIScrollViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        guard let currentInput = TextFieldType(rawValue: currentPage) else { return }
        self.currentInput = currentInput
    }
}

// MARK: CreditCardDataDelegate

extension CardInputsView: CreditCardDataDelegate {

    /// - SeeAlso: CreditCardDataDelegate.beganEditing(textFieldType:)
    public func beganEditing(in textFieldType: TextFieldType) {
        var pageFrame: CGRect = frame
        pageFrame.origin.x = pageFrame.size.width * CGFloat(textFieldType.rawValue)
        pageFrame.origin.y = 0
        scrollRectToVisible(pageFrame, animated: true)
    }

    /// - SeeAlso: CreditCardDataDelegate.cardNumberChanged(number:)
    public func cardNumberChanged(_ number: String) {
        cardNumberField.inputField.text = number
    }

    /// - SeeAlso: CreditCardDataDelegate.cardholderNameChanged(name:)
    public func cardholderNameChanged(_ name: String) {
        cardholderNameField.inputField.text = name
    }

    /// - SeeAlso: CreditCardDataDelegate.validityDateChanged(date:)
    public func validityDateChanged(_ date: String) {
        var formattedDate = date
        if formattedDate.count > 2 {
            formattedDate.insert(contentsOf: validityDateSeparator, at: formattedDate.index(formattedDate.startIndex, offsetBy: 2))
        }
        validityDateField.inputField.text = formattedDate
    }

    /// - SeeAlso: CreditCardDataDelegate.CVVNumberChanged(cvv:)
    public func CVVNumberChanged(_ cvv: String) {
        CVVNumberField.inputField.text = cvv
    }
}

// MARK: CreditCardDataProvider

extension CardInputsView: CreditCardDataProvider {

    /// - SeeAlso: CreditCardDataProvider.creditCardData
    public var creditCardData: CreditCardData {
        guard
            let cardNumber = cardNumberField.inputField.text,
            let cardholderName = cardholderNameField.inputField.text,
            let validityDate = validityDateField.inputField.text,
            let CVVNumber = CVVNumberField.inputField.text
        else {
            return CreditCardData()
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
