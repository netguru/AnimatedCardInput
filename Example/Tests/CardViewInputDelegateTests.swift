//
//  CardViewInputDelegateTests.swift
//  AnimatedCardInput_Tests
//

import XCTest
import AnimatedCardInput

class CardViewInputDelegateTests: XCTestCase {

    var sut: CardView!
    var resourceBundle: Bundle?

    override func setUp() {
        super.setUp()
        sut = CardView()
        resourceBundle = {
            let frameworkBundle = Bundle(for: CardView.self)
            if let resourceBundlePath = frameworkBundle.path(forResource: "AnimatedCardInput", ofType: "bundle") {
                return Bundle(path: resourceBundlePath)
            }
            return frameworkBundle
        }()
    }

    func testUpdateCardProviderVisa() throws {
        sut.updateCardProvider(cardNumber: "4")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "visa.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderMastercard() throws {
        sut.updateCardProvider(cardNumber: "5")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "mastercard.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderDiscover() throws {
        sut.updateCardProvider(cardNumber: "6")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "discover.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderAmericanExpress4() throws {
        sut.updateCardProvider(cardNumber: "34")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "american_express.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderAmericanExpress7() throws {
        sut.updateCardProvider(cardNumber: "37")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "american_express.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderDiners0() throws {
        sut.updateCardProvider(cardNumber: "30")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "diners_club.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderDiners6() throws {
        sut.updateCardProvider(cardNumber: "36")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "diners_club.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderDiners8() throws {
        sut.updateCardProvider(cardNumber: "38")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "diners_club.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderJCB() throws {
        sut.updateCardProvider(cardNumber: "35")
        XCTAssertEqual(sut.cardProviderImage, UIImage(named: "jcb.png", in: resourceBundle, compatibleWith: nil))
    }

    func testUpdateCardProviderVisaNotSupported() throws {
        sut.updateCardProvider(cardNumber: "9")
        XCTAssertEqual(sut.cardProviderImage, nil)
    }

    func testUpdateCardProviderVisaNotSupported3() throws {
        sut.updateCardProvider(cardNumber: "39")
        XCTAssertEqual(sut.cardProviderImage, nil)
    }
}
