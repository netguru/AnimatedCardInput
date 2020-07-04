//
//  CardProvider.swift
//  AnimatedCardInput
//

/// Represents a provider of Credit Cards.
public class CardProvider {

    // MARK: Parameters

    /// Name of Card Provider.
    public let name: String

    /// Icon with logo of Card Provider.
    public let icon: UIImage?

    /// String pattern for recognizing card brand from the card number.
    private let pattern: String

    /// Regular Expression for recognizing card brand from the card number.
    private var regex: NSRegularExpression? {
        try? NSRegularExpression(pattern: "^\(pattern)\\d*")
    }

    // MARK: Providers Collections

    /// Collection of card providers added by the application.
    public static var customCardProviders = Set<CardProvider>()

    /// Collection of default Card Providers.
    private static let defaultProfiders: [CardProvider] = [
        /// VISA starts with `4`.
        CardProvider(name: "Visa", assetName: "visa.png", pattern: "4"),
        /// MasterCard starts with `5`.
        CardProvider(name: "Mastercard", assetName: "mastercard.png", pattern: "5"),
        /// Discover starts with `6`.
        CardProvider(name: "Discover", assetName: "discover.png", pattern: "6"),
        /// American Express starts with `34` or `37`.
        CardProvider(name: "American Express", assetName: "american_express.png", pattern: "3[4,7]"),
        /// Diners Club starts with `30`, `36` or `38`.
        CardProvider(name: "Diners Club", assetName: "diners_club.png", pattern: "3[0,6,8]"),
        /// JCB starts with `35`.
        CardProvider(name: "JCB", assetName: "jcb.png", pattern: "35"),
    ]

    // MARK: Initializers

    /// Initializes instance of Card Provider.
    ///
    /// - Parameters:
    ///     - name: name of Card Provider.
    ///     - icon: optional icon of Card Provider.
    ///     - pattern: pattern for recognizing Card Provider from card number. This will be applied as a regex `^\(pattern)\\d*`.
    init(name: String, icon: UIImage?, pattern: String) {
        self.name = name
        self.icon = icon
        self.pattern = pattern
    }

    /// Initializes instance of default Card Provider.
    /// - Parameters:
    ///     - name: name of Card Provider.
    ///     - assetName: name of asset for Card Provider icon.
    ///     - pattern: pattern for recognizing Card Provider from card number.
    private init(name: String, assetName: String, pattern: String) {
        self.name = name
        self.pattern = pattern
        self.icon = {
            let resourceBundle: Bundle? = {
                let frameworkBundle = Bundle(for: CardView.self)
                if let resourceBundlePath = frameworkBundle.path(forResource: "AnimatedCardInput", ofType: "bundle") {
                    return Bundle(path: resourceBundlePath)
                }
                return frameworkBundle
            }()
            return UIImage(named: assetName, in: resourceBundle, compatibleWith: nil)
        }()
    }

    // MARK: Static

    /// Add custom providers to the collection used for recognition from card number.
    /// - Parameters:
    ///     - providers: Collection of custom providers to add for brand recognition.
    public static func addCardProviders(_ providers: CardProvider...) {
        providers.forEach { customCardProviders.insert($0) }
    }

    /// Recognizes `Card Provider` from the card number.
    /// - Parameters:
    ///     - cardNumber: Card Number to recognize from.
    /// - Returns: `Card Provider` object if card number matches any of available patterns.
    public static func recognizeProvider(from cardNumber: String) -> CardProvider? {
        let range = NSRange(location: 0, length: cardNumber.utf16.count)
        for provider in defaultProfiders + customCardProviders {
            if provider.regex?.firstMatch(in: cardNumber, options: [], range: range) != nil {
                return provider
            }
        }
        return nil
    }
}

// MARK: Hashable

extension CardProvider: Hashable {

    /// - SeeAlso: Hashable.hash(into:)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(pattern)
    }

    /// - SeeAlso: Equatable.==(lhs:, rhs:)
    public static func == (lhs: CardProvider, rhs: CardProvider) -> Bool {
        lhs.name == rhs.name && lhs.pattern == rhs.pattern
    }
}
