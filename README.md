# AnimatedCardInput

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/krysztalzg/AnimatedCardInput/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/AnimatedCardInput.svg)](http://cocoapods.org/pods/AnimatedCardInput)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg)](https://developer.apple.com/swift/)

This library allows you to drop into your project two easily customisable, animated components that will make input of Credit Card information for users much better experience.
<p align="center">
	<img src="https://user-images.githubusercontent.com/6009785/82156049-4ab40d00-9879-11ea-9c1e-ef5ab53f94bd.gif" width="300">
</p>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

*AnimatedCardInput* is written in **Swift 5.0** and supports **iOS 11.0+**.

## Installation

*AnimatedCardInput* is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AnimatedCardInput'
```

## Usage

Both components available in this Pod can be used either individually or in pair on one screen.

### Card View
![cardViewBothsides](https://user-images.githubusercontent.com/6009785/82155437-4e459500-9875-11ea-8242-a09f83f7af52.png)
To use Card View on our screen we simply initialise the view and place it in our hierarchy. This will create default credit card view, with 16-digit card number separated into blocks of 4 and CVV number limited to 3 digits.
```swift
/// cardNumberDigitsLimit: Indicates maximum length of card number. Defaults to 16.
/// cardNumberChunkLengths: Indicates format of card number,
///                         e.g. [4, 3] means that number of length 7 will be split
///                         into two parts of length 4 and 3 respectively (XXXX XXX).
/// CVVNumberDigitsLimit: Indicates maximum length of CVV number.
let cardView = CardView(
    cardNumberDigitsLimit: 16,
    cardNumberChunkLengths: [4, 4, 4, 4],
    CVVNumberDigitsLimit: 3
)
view.addSubview(cardView)
NSLayoutConstraint.activate([...])
```
We can customise our card view in almost every way. Starting with the design, both fonts and color can be adjusted. Here's a list of all available properties that can be changed.

* `isSecureInput` - Enables masking ov CVV number (defaults to false).
* `validatesDateInput` - Enables validation on Validity Date Field (defaults to true).
* `frontSideCardColor` - Background color of the card's front side (defaults to #373737).
* `frontSideTextColor` - Text color of the card's front side (defaults to #FFFFFF).
* `backSideCardColor` - Background color of the card's back side (defaults to #373737).
* `CVVBackgroundColor` - Background color of the card's CVV Field (defaults to #FFFFFF).
* `backSideTextColor` - Text color of the card's back side (defaults to #000000).
* `selectionIndicatorColor` - Border color of a selected field indicator (defaults to #ff8000).
* `numberInputFont` - Font of the Card Number Field (defaults to System SemiBold 24).
* `nameLabelFont` - Font of the Cardholder Name Label (defaults to System Light 14. Recommended font size is 0.6 of Card Number size).
* `nameInputFont` - Font of the Cardholder Name Field (defaults to System Regular 14. Recommended font size is 0.6 of Card Number size).
* `validityLabelFont` - Font of the Validity Date Label (defaults to System Light 14. Recommended font size is 0.6 of Card Number size).
* `validityInputFont` - Font of the Validity Date Field (defaults to System Regular 14. Recommended font size is 0.6 of Card Number size).
* `CVVInputFont` - Font of the CVV Number Field (defaults to System SemiBold 20. Recommended font size is 0.85 of Card Number size).
* `cardNumberSeparator` - Character used as the Card Number Separator (defaults to " ").
* `cardNumberEmptyCharacter` - Character used as the Card Number Empty Character (defaults to "X").
* `validityDateSeparator` - Character used as the Validity Date Separator (defaults to "/").
* `validityDateCustomPlaceHolder` - Text used as the Validity Date Placeholder (defaults to "MM/YY").
* `CVVNumberEmptyCharacter` - Character used as CVV Number Empty Character (defaults to "X").
* `cardholderNameTitle` - Custom string to use for title label of Cardholder Name input.
* `cardholderNamePlaceholder` - Custom string to use for placeholder of Cardholder Name input.
* `validityDateTitle` - Custom string to use for title label of Validity Date input.

### Card Inputs View
![CardInputsViewCardholderName](https://user-images.githubusercontent.com/6009785/82155441-500f5880-9875-11ea-85f4-95920ff23e3d.png)
To use Card Inputs View on our screen we simply initialise the view and place it in our hierarchy. This will create default default scroll view with four text fields and card number limited to 16 digits.
```swift
let cardInputsView = CardInputsView(cardNumberDigitLimit: 16)
view.addSubview(cardInputsView)
NSLayoutConstraint.activate([...])
```
Input views can be customised all at once with following properties.
* `isSecureInput` - Enables masking ov CVV number (defaults to false).
* `validatesDateInput` - Enables validation on Validity Date Field (defaults to true).
* `inputTintColor` - Color of tint for text fields (defaults to #000000).
* `inputborderColor` - Color of border for text fields (defaults to #808080).
* `titleColor` - Color of text in title label (defaults to #000000).
* `titleFont` - Font of text in title label (defaults to System Light 12).
* `inputColor` - Color of text in text field (defaults to #000000).
* `inputFont` - Font of text in text field (defaults to System Regular 24).
* `cardNumberTitle` - Custom string to use for title label of Card Number input.
* `cardholderNameTitle` - Custom string to use for title label of Cardholder Name input.
* `validityDateTitle` - Custom string to use for title label of Validity Date input.
* `cvvNumberTitle` - Custom string to use for title label of CVV Code input.

### Connecting both components
If we want users to input data either directly onto card or by selecting textfields we need to pair both components with `creditCardDataDelegate` property.
```swift
cardView.creditCardDataDelegate = inputsView
cardInputsView.creditCardDataDelegate = cardView
```
From now on both inputs will update to the same data and step in the filling flow.

### Adding new Card Providers
If default card brands provided with this library are not enough for your needs, you can add your own Card Provider with custom name, icon and recognition pattern that will be used in regex (`"^\(pattern)\\d*"), eg. a fake _Cardinio_ provider that have card numbers starting with `92` or `95`:
```swift
let newCardProvider = CardProvider(name: "Cardinio", image: #imageLiteral(resourceName: "cardinio_icon"), pattern: "9[2,5]")
CardProvider.addCardProviders(newCardProvider)
```

## Roadmap
* [x] Labels localisation.
* [x] Adding new, custom credit card providers with icons.
* [ ] Validation errors displayed on the inputs.
* [ ] Even more...

## About

This project is made with ❤️ by [Netguru](https://netguru.com) and maintained by [Kamil Szczepański](https://github.com/krysztalzg).

## License

*AnimatedCardInput* is available under the MIT license. See the LICENSE file for more info.
