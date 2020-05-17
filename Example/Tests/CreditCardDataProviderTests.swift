import XCTest
import AnimatedCardInput

class CreditCardDataProvider: XCTestCase {
    
    func testRetrievingCreditCardDataFromCardView() {
        let sut = CardView()
        XCTAssertNotNil(sut.creditCardData)
    }

    func testRetrievingCreditCardDataFromCardInputsView() {
        let sut = CardInputsView(cardNumberDigitLimit: 1)
        XCTAssertNotNil(sut.creditCardData)
    }
}
