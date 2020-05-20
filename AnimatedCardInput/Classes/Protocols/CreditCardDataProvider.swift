//
//  CreditCardDataProvider.swift
//  AnimatedCardInput
//

/// Protocol for retrieving all user inputs as `Credit Card Data` object.
public protocol CreditCardDataProvider: AnyObject {

    /// Object representing data of the Credit Card.
    var creditCardData: CreditCardData { get }
}
