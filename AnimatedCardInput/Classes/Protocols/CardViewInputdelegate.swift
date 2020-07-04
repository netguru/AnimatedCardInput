//
//  CardViewInputdelegate.swift
//  AnimatedCardInput
//

/// Protocol for handling text field interactions.
public protocol CardViewInputDelegate: AnyObject {

    /// Informs `Card View` about currently selected field.
    /// - Parameters:
    ///     - type: type of selected field.
    func updateCurrentInput(to type: TextFieldType)

    /// Informs that focus should be updated to next field in `TextFieldType` order.
    func moveToNextTextField()

    /// Informs that focus should be updated to previous field in `TextFieldType` order.
    func moveToPreviousTextField()

    /// Informs that finishing has been finished.
    func finishEditing()

    /// Informs `Card View` about card number changes used for updating card provider icon.
    /// - Parameters:
    ///     - cardNumber: current input of `Card Number` field.
    func updateCardProvider(cardNumber: String)

    /// Informs `Card View` that selection indicator should be updated to focused field.
    func updateSelectionIndicator()
}
