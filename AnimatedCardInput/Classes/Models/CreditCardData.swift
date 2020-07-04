//
//  CreditCardData.swift
//  AnimatedCardInput
//

import Foundation

public struct CreditCardData {

    /// Object representing card's provider.
    public var cardProvider: CardProvider?

    /// String representing Number of the Credit Card.
    public var cardNumber: String = ""

    /// String representing Name of the Cardholder's.
    public var cardholderName: String = ""

    /// String representing Validity Date of the Credit Card.
    public var validityDate: String = ""

    /// String representing CVV Number of the Credit Card.
    public var CVVNumber: String = ""
}
