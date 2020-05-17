//
//  TextFieldType.swift
//  AnimatedCardInput
//

/// Types of available text fields, used to handle progressing though input flow.
public enum TextFieldType: Int, CaseIterable {
    case cardNumber = 0
    case cardholderName
    case validityDate
    case CVVNumber

    case none
}
