//
//  CardViewInputdelegate.swift
//  AnimatedCardInput
//

/// Protocol for handling text field interactions.
public protocol CardViewInputDelegate: class {

    func updateCurrentInput(to type: TextFieldType)
    func moveToNextTextField()
    func moveToPreviousTextField()
    func finishEditing()
    func updateCardProvider(cardNumber: String)
    func updateSelectionIndicator()
}
