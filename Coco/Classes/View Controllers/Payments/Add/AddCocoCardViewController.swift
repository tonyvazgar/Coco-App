//
//  AddCocoCardViewController.swift
//  Coco
//
//  Created by Carlos Banos on 2/19/21.
//  Copyright © 2021 Easycode. All rights reserved.
//

import UIKit

final class AddCocoCardViewController: UIViewController {
    @IBOutlet private var cardView: UIView!
    @IBOutlet private var redeemCodeButton: UIButton!
    @IBOutlet private var codeTextField: UITextField!
    
    private var loader = LoaderVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func redeemCodeAction(_ sender: Any) {
        redeemCode()
    }
}

// MARK: - Configure View

private extension AddCocoCardViewController {
    func configureView() {
        cardView.layer.cornerRadius = 8
        // border
        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        // shadow
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowRadius = 2
        
        codeTextField.clipsToBounds = true
        codeTextField.addBottomBorder(thickness: 1, color: .lightGray)
        redeemCodeButton.roundCorners(12)
    }
}

// MARK: - Redeem Code Request

extension AddCocoCardViewController {
    func redeemCode() {
        guard let token = codeTextField.text, !token.isEmpty else {
            throwError(str: "Favor de ingresar un código válido.")
            return
        }
        loader.showInView(aView: view, animated: true)
        PaymentMethodsFetcher.redeemCocoCard(token: token) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error as FetcherErrors):
                self?.throwError(str: error.localizedDescription)
            case .failure:
                self?.throwError(str: "Ocurrió un error al procesar la tarjeta, favor de contactar a soporte técnico.")
            case .success:
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
