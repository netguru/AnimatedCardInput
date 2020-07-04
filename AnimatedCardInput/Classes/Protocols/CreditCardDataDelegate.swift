//
//  CreditCardDataDelegate.swift
//  AnimatedCardInput
//

/// Protocol used to inform paired views about input changes.
public protocol CreditCardDataDelegate: AnyObject {

    /// Informs that user began input of data for given Field Type.
    /// - Parameters:
    ///     - textFieldType: Type of Text Field that is currently being edited.
    func beganEditing(in textFieldType: TextFieldType)

    /// Informs that card number input has changed.
    /// - Parameters:
    ///     - number: String value of changed Card Number.
    func cardNumberChanged(_ number: String)

    /// Informs that cardholder's name input has changed.
    /// - Parameters:
    ///     - name: String value of changed Cardholder Name.
    func cardholderNameChanged(_ name: String)

    /// Informs that card's validity date input has changed.
    /// - Parameters:
    ///     - date: String value of changed Card Validity Date.
    func validityDateChanged(_ date: String)

    /// Informs that card's CVV number input has changed.
    /// - Parameters:
    ///     - cvv: String value of changed CVV Number.
    func CVVNumberChanged(_ cvv: String)
}
