//
//  CreditCardDataDelegateTests.swift
//  AnimatedCardInput_Tests
//

import XCTest
@testable import AnimatedCardInput

class CreditCardDataDelegateTests: XCTestCase {

    var sut: CardView!

    override func setUp() {
        super.setUp()
        sut = CardView()
    }

    func testCardNumberChanged() throws {
        sut.cardNumberChanged("newnumber")
        XCTAssertEqual(sut.creditCardData.cardNumber, "newnumber")
    }

    func testCardNumberChangedEmptyString() throws {
        sut.cardNumberChanged("")
        XCTAssertEqual(sut.creditCardData.cardNumber, "")
    }

    func testCardholderNameChanged() throws {
        sut.cardholderNameChanged("new carholder name")
        XCTAssertEqual(sut.creditCardData.cardholderName, "new carholder name".uppercased())
    }

    func testCardholderNameChangedEmptyString() throws {
        sut.cardholderNameChanged("")
        XCTAssertEqual(sut.creditCardData.cardholderName, "")
    }

    func testCValidityDateChanged() throws {
        sut.validityDateChanged("1124")
        XCTAssertEqual(sut.creditCardData.validityDate, "11/24")
    }

    func testCValidityDateChangedEmptyString() throws {
        sut.validityDateChanged("")
        XCTAssertEqual(sut.creditCardData.validityDate, "")
    }

    func testCValidityDateChangedHalfString() throws {
        sut.validityDateChanged("11")
        XCTAssertEqual(sut.creditCardData.validityDate, "11")
    }

    func testCValidityDateChangedQuarterString() throws {
        sut.validityDateChanged("113")
        XCTAssertEqual(sut.creditCardData.validityDate, "11/3")
    }

    func testCVVNumberChanged() throws {
        sut.CVVNumberChanged("123")
        XCTAssertEqual(sut.creditCardData.CVVNumber, "123")
    }

    func testCVVNumberChangedEmptyString() throws {
        sut.CVVNumberChanged("")
        XCTAssertEqual(sut.creditCardData.CVVNumber, "")
    }
}
