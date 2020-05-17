//
//  ViewController.swift
//  AnimatedCardInput
//

import UIKit
import AnimatedCardInput

class ViewController: UIViewController {

    private let cardView: CardView = {
        let view = CardView(
            cardNumberDigitsLimit: 16,
            cardNumberChunkLengths: [4, 4, 4, 4],
            CVVNumberDigitsLimit: 3
        )

        view.frontSideCardColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        view.backSideCardColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        view.selectionIndicatorColor = .orange
        view.frontSideTextColor = .white
        view.CVVBackgroundColor = .white
        view.backSideTextColor = .black

        view.numberInputFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        view.nameInputFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.validityInputFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.CVVInputFont = UIFont.systemFont(ofSize: 20, weight: .semibold)

        return view
    }()

    private let inputsView: CardInputsView = {
        let view = CardInputsView(cardNumberDigitLimit: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let retrieveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" Retrieve data ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retrieveTapped), for: .touchUpInside)
        return button
    }()

    private let previewTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.isUserInteractionEnabled = false
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.creditCardDataDelegate = inputsView
        inputsView.creditCardDataDelegate = cardView

        [
            cardView,
            inputsView,
            retrieveButton,
            previewTextView
        ].forEach(view.addSubview)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            inputsView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            inputsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            retrieveButton.heightAnchor.constraint(equalToConstant: 44),
            retrieveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retrieveButton.topAnchor.constraint(equalTo: inputsView.bottomAnchor, constant: 24),

            previewTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewTextView.topAnchor.constraint(equalTo: retrieveButton.bottomAnchor, constant: 32),
            previewTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            previewTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            previewTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardView.currentInput = .cardNumber
    }

    @objc private func retrieveTapped() {
        let data = cardView.creditCardData
        previewTextView.text = "\(data.cardNumber)\n\(data.cardholderName)\n\(data.validityDate)\n\(data.CVVNumber)"
    }
}

