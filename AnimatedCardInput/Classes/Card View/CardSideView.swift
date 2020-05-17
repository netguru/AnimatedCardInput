//
//  CardSideView.swift
//  AnimatedCardInput
//

import UIKit

/// Base class used for implementation of front and back side views of a Credit Card.
internal class CardSideView: UIView {

    // MARK: Hierarchy

    /// Toolbar button for finishing the editing.
    internal var finishToolbarButton: UIBarButtonItem {
        UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishEditing))
    }

    /// Toolbar button for progressing to next Text Field.
    internal var nextToolbarButton: UIBarButtonItem {
        UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTextField))
    }

    /// Toolbar button for returning to previous Text Field.
    internal var previousToolbarButton: UIBarButtonItem {
        UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousTextField))
    }

    /// Toolbar item for flexible spacing.
    internal var spacingToolbarItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }

    /// Displays image for current card provider.
    internal lazy var cardProviderView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()

    /// Width constraint that ensures cardProviderIcon is properly aligned to right side after applying aspectFit scaling.
    private var cardProviderIconWidthConstraint: NSLayoutConstraint?

    // MARK: Properties

    /// - seeAlso: CardViewInputSelectionDelegate
    internal weak var inputDelegate: CardViewInputDelegate?

    /// Color of texts for Text Fields Labels on this Card Side.
    internal var textColor: UIColor? = .white {
        didSet {
            updateTextColor()
        }
    }

    /// Duration of showing/hiding `Card Provider Image View`. Defaults to 0.2.
    internal var cardProviderAnimationDuration: TimeInterval = 0.2

    /// Image for current card provider.
    internal var cardProviderImage: UIImage? {
        didSet {
            if let image = cardProviderImage {
                cardProviderView.image = cardProviderImage
                cardProviderIconWidthConstraint?.isActive = false
                cardProviderIconWidthConstraint = cardProviderView.widthAnchor.constraint(equalTo: cardProviderView.heightAnchor, multiplier: image.size.width / image.size.height)
                cardProviderIconWidthConstraint?.priority = .required
                cardProviderIconWidthConstraint?.isActive = true
            }

            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: cardProviderAnimationDuration,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.cardProviderView.alpha = self.cardProviderImage == nil ? 0 : 1
                },
                completion: { _ in
                    if self.cardProviderImage == nil {
                        self.cardProviderView.image = nil
                    }
                }
            )
        }
    }

    // MARK: Initializers

    /// Initializes instance of CardSideView and setups basic properties.
    init() {
        super.init(frame: .zero)

        setupProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    /// Performs setup of basic properties with their default values.
    internal func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
    }

    /// Updates text color of all appropiate views.
    internal func updateTextColor() { }

    // MARK: Private

    /// Informs Selection Delegate to progress to next Text Field.
    @objc private func nextTextField() {
        inputDelegate?.moveToNextTextField()
    }

    /// Informs Selection Delegate to return to previous Text Field.
    @objc private func previousTextField() {
        inputDelegate?.moveToPreviousTextField()
    }

    /// Informs Selection Delegate to finish editing.
    @objc private func finishEditing() {
        inputDelegate?.finishEditing()
    }
}
