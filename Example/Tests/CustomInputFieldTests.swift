//
//  CustomInputFieldTests.swift
//  AnimatedCardInput_Tests
//

import XCTest
@testable import AnimatedCardInput

class CustomInputFieldTests: XCTestCase {

    var sut: CustomInputField!

    override func setUp() {
        super.setUp()
        sut = CustomInputField()
    }

    func testInputHasChanged() throws {
        sut.inputHasChanged(to: "newInput")
        XCTAssertEqual(sut.text, "newInput")
    }

    func testInputHasChangedEmptyString() throws {
        sut.inputHasChanged(to: "")
        XCTAssertEqual(sut.text, "")
    }
}
