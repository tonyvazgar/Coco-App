//
//  AddCardVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol AddCardDelegate {
  func didAddCard()
}

class AddCardVC: UIViewController {
  
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
  var delegate: AddCardDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    callValues()
  }
  
  private func configureView() {
    chargeButton.roundCorners(12)
  }
  
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
        
        print(data)
      guard let dataCard = data,
        let id = dataCard["id"] else {
            print(data)
          self.loader.removeAnimate()
          self.throwError(str: "No se pudo procesar la tarjeta")
          return
      }
      let type = cardNo.prefix(1) == "4" ? "VISA" : cardNo.prefix(1) == "5" ? "MASTER CARD" : "AMEX"
      
      let newCard = Cards(name: name, address: address, second_address: address_2, zip: zip, number: phone, digits: String(cardNo.suffix(4)), type: type, token: "\(id)", auto: self.switchAutoCharge.isOn ? "1" : "0", amount: amount)
      
      newCard.addCard(completion: { (result) in
        switch result {
        case .failure(let errorMssg):
          self.loader.removeAnimate()
          self.throwError(str: errorMssg)
        case .success(_):
          self.delegate.didAddCard()
          self.dismiss(animated: true, completion: nil)
        }
      })
    }, andError: { (error) -> Void in
        print(error)
      self.loader.removeAnimate()
      self.throwError(str: "Ocurrió un error al procesar la tarjeta")
    })
    
    // Adding values to defaults so next time it loads the textfields are already filled. You need to call the callValues function on the viewDidLoad for it to work.
    
    UserDefaults.standard.set(cardNo, forKey: "cardNumber")
    UserDefaults.standard.set(monthExp, forKey: "month")
    UserDefaults.standard.set(yearExp, forKey: "year")
    UserDefaults.standard.set(name, forKey: "name")
    UserDefaults.standard.set(address, forKey: "address")
    UserDefaults.standard.set(address_2, forKey: "Hood")
    UserDefaults.standard.set(zip, forKey: "zip")
    UserDefaults.standard.set(phone, forKey: "phone")
    
  }
    
    func callValues() {
        
        // Fill the values with the previus input from the user.
        
        cardNumberField.text = UserDefaults.standard.string(forKey: "cardNumber") ?? ""
        monthExpField.text = UserDefaults.standard.string(forKey: "month") ?? ""
        yearExpField.text = UserDefaults.standard.string(forKey: "year") ?? ""
        cardholderNameField.text = UserDefaults.standard.string(forKey: "name") ?? ""
        addressField.text = UserDefaults.standard.string(forKey: "address") ?? ""
        address2Field.text = UserDefaults.standard.string(forKey: "Hood") ?? ""
        zipCodeField.text = UserDefaults.standard.string(forKey: "zip") ?? ""
        phoneField.text = UserDefaults.standard.string(forKey: "phone") ?? ""
        
    }
  
  private func validateField(txtField: UITextField) -> String? {
    guard let text = txtField.text else { return nil}
    if text == "" {
      return nil
    }
    return text
  }
}
