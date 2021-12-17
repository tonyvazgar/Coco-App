//
//  AddPaymentMethodViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/20/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol AddPaymentMethodDelegate: AnyObject {
    func didAddCard()
}

class AddPaymentMethodViewController: UIViewController {
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var monthExpField: UITextField!
    @IBOutlet weak var yearExpField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var cardholderNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var amountRechargeField: UITextField!
    @IBOutlet weak var switchAutoCharge: UISwitch!
    @IBOutlet weak var chargeButton: UIButton!
    
    var loader: LoaderVC!
    weak var delegate: AddPaymentMethodDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        chargeButton.roundCorners(12)
        cardNumberField.addBottomBorder(thickness: 1, color: .lightGray)
        monthExpField.addBottomBorder(thickness: 1, color: .lightGray)
        yearExpField.addBottomBorder(thickness: 1, color: .lightGray)
        cvvField.addBottomBorder(thickness: 1, color: .lightGray)
        cardholderNameField.addBottomBorder(thickness: 1, color: .lightGray)
        addressField.addBottomBorder(thickness: 1, color: .lightGray)
        address2Field.addBottomBorder(thickness: 1, color: .lightGray)
        zipCodeField.addBottomBorder(thickness: 1, color: .lightGray)
        phoneField.addBottomBorder(thickness: 1, color: .lightGray)
        amountRechargeField.addBottomBorder(thickness: 1, color: .lightGray)
        
        cardNumberField.clipsToBounds = true
        monthExpField.clipsToBounds = true
        yearExpField.clipsToBounds = true
        cvvField.clipsToBounds = true
        cardholderNameField.clipsToBounds = true
        addressField.clipsToBounds = true
        address2Field.clipsToBounds = true
        zipCodeField.clipsToBounds = true
        phoneField.clipsToBounds = true
        amountRechargeField.clipsToBounds = true
    }
    
    @IBAction private func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chargeAction(_ sender: Any) {
        guard let cardNo = validateField(txtField: cardNumberField),
              let monthExp = validateField(txtField: monthExpField),
              let yearExp = validateField(txtField: yearExpField),
              let cvc = validateField(txtField: cvvField),
              let name = validateField(txtField: cardholderNameField),
              let address = validateField(txtField: addressField),
              let address_2 = validateField(txtField: address2Field),
              let zip = validateField(txtField: zipCodeField),
              let phone = validateField(txtField: phoneField),
              let amount = validateField(txtField: amountRechargeField) else {
            throwError(str: "Favor de llenar todos los campos")
            return
        }
        
        if  Int(amount)! < 200 {
            throwError(str: "El monto a recargar no puede ser menor a $ 200")
            return
        }
        showLoader(&loader, view: view)
        
        let conekta = Conekta()
        conekta.delegate = self
        //    conekta.publicKey = "key_FRuv2dzqzxv4MRAeutBstyA" // Sandbox
        conekta.publicKey = "key_dQ9sxJszryxrFw1XiNnBD9Q" // Production
        conekta.collectDevice()
        guard let card = conekta.card(), let token = conekta.token() else {
            throwError(str: "No se pudo procesar la tarjeta.")
            return
        }
        card.setNumber(cardNo, name: name, cvc: cvc, expMonth: monthExp, expYear: yearExp)
        token.card = card
        token.create(success: { (data) -> Void in
            print(data as Any)
            guard let dataCard = data,
                  let id = dataCard["id"] else {
                print(data as Any)
                self.loader.removeAnimate()
                self.throwError(str: "No se pudo procesar la tarjeta")
                return
            }
            let type = cardNo.prefix(1) == "4" ? "VISA" : cardNo.prefix(1) == "5" ? "MASTER CARD" : "AMEX"
            
            let newCard = Cards(name: name, address: address, second_address: address_2, zip: zip, number: phone, digits: String(cardNo.suffix(4)), type: type, token: "\(id)", auto: self.switchAutoCharge.isOn ? "1" : "0", amount: amount)
            
            newCard.addCard(completion: { [weak self] result in
                switch result {
                case .failure(let errorMssg):
                    self?.loader.removeAnimate()
                    self?.throwError(str: errorMssg)
                case .success(_):
                    self?.delegate?.didAddCard()
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        }, andError: { (error) -> Void in
            print(error as Any)
            self.loader.removeAnimate()
            self.throwError(str: "Ocurrió un error al procesar la tarjeta")
        })
    }
    
    private func validateField(txtField: UITextField) -> String? {
        guard let text = txtField.text else { return nil}
        if text == "" {
            return nil
        }
        return text
    }
}
