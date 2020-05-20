//
//  CardProvider.swift
//  AnimatedCardInput
//

/// Possible Card Providers to dispaly icon on `Card View`.
public enum CardProvider {

    case visa
    case mastercard
    case discover
    case americanExpress
    case dinersClub
    case jcb
    /// When provider is not recognized from card number.
    case notRecognized

    /// Initializes `Card Provider` instance.
    /// Parameters:
    ///     - cardNumber: Card number for provider recognition.
    init(cardNumber: String) {
        guard let firstNumber = cardNumber.first else { self = .notRecognized; return }
        switch firstNumber {
            /// VISA starts with `4`.
            case "4":
                self = .visa
            /// MasterCard  starts with `5`.
            case "5":
                self = .mastercard
            /// Discover starts with `6`.
            case "6":
                self = .discover
            case "3":
                guard cardNumber.count > 1 else { self = .notRecognized; return }
                let secondNumber = cardNumber[cardNumber.index(cardNumber.startIndex, offsetBy: 1)]
                switch secondNumber {
                    /// American Express starts with `34` or `37`.
                    case "4", "7":
                        self = .americanExpress
                    /// Diners Club starts with `30`, `36` or `38`.
                    case "0", "6", "8":
                        self = .dinersClub
                    /// JCB starts with `35`.
                    case "5":
                        self = .jcb
                    default:
                        self = .notRecognized
                }
            default:
                self = .notRecognized
        }
    }

    /// Icon for card provider.4
    public var icon: UIImage? {
        let resourceBundle: Bundle? = {
            let frameworkBundle = Bundle(for: CardView.self)
            if let resourceBundlePath = frameworkBundle.path(forResource: "AnimatedCardInput", ofType: "bundle") {
                return Bundle(path: resourceBundlePath)
            }
            return frameworkBundle
        }()
        guard self != .notRecognized else { return nil }
        return UIImage(named: assetName, in: resourceBundle, compatibleWith: nil)
    }

    private var assetName: String {
        switch self {
            case .visa:
                return "visa.png"
            case .mastercard:
                return "mastercard.png"
            case .discover:
                return "discover.png"
            case .americanExpress:
                return "american_express.png"
            case .dinersClub:
                return "diners_club.png"
            case .jcb:
                return "jcb.png"
        case .notRecognized:
                return ""
        }
    }
}
