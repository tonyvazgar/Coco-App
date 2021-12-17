//
//  PaymentFormsVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol PaymentFormsDelegate {
  func didChangePaymentForms()
}

class PaymentFormsVC: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var addCardButton: UIButton!
  
  var loader: LoaderVC!
  var paymentForms: PaymentForms!
  var delegate: PaymentFormsDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    paymentForms = PaymentForms()
    configureView()
    configureTable()
    requestData()
  }
  
  private func configureView() {
    addCardButton.roundCorners(12)
  }
  
  private func configureTable() {
    table.separatorStyle = .none
    table.delegate = self
    table.dataSource = self
    table.tableFooterView = UIView()
    let nib = UINib(nibName: PaymentFormsTableViewCell.cellIdentifier, bundle: nil)
    table.register(nib, forCellReuseIdentifier: PaymentFormsTableViewCell.cellIdentifier)
  }
  
  private func requestData() {
    showLoader(&loader, view: view)
    paymentForms.requestPaymentForms { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
        print(errorMssg)
      case .success(_):
        self.fillInfo()
      }
    }
  }
  
  private func fillInfo() {
    table.reloadData()
  }
  
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addCardAction(_ sender: Any) {
    let vc = instantiate(viewControllerClass: AddCardVC.self, storyBoardName: "CardsStoryboard")
    vc.delegate = self
    present(vc, animated: true)
  }
}

extension PaymentFormsVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return paymentForms.paymentForm.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentFormsTableViewCell.cellIdentifier, for: indexPath) as? PaymentFormsTableViewCell else {
      return UITableViewCell()
    }
    let item = paymentForms.paymentForm[indexPath.row]
    cell.delegate = self
    cell.index = indexPath.row
    cell.digitsLabel.text = "**** **** **** \(item.digits ?? "****")"
    
    if paymentForms.paymentForm[indexPath.row].type == "VISA" {
        
        cell.typeOfCard.image = UIImage(named: "visa_sola")
        
    } else if paymentForms.paymentForm[indexPath.row].type == "MASTER CARD" {
        
        cell.typeOfCard.image = UIImage(named: "mastercard")
        
    } else if paymentForms.paymentForm[indexPath.row].type == "AMEX" {
        
        cell.typeOfCard.image = UIImage(named: "amex")
        
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}

extension PaymentFormsVC: PaymentFormCellDelegate {
  func didTapDeletePaymentForm(index: Int) {
    let alert = UIAlertController(title: "¿Deseas eliminar esta tarjeta de tu perfil?", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (_) in
      self.showLoader(&self.loader, view: self.view)
      self.paymentForms.paymentForm[index].removePaymentForm { result in
        self.loader.removeAnimate()
        switch result {
        case .failure(let errorMssg):
          self.throwError(str: errorMssg)
        case .success(_):
          self.requestData()
        }
      }
    }))
    present(alert, animated: true)
  }
    
    func didChoseAPayment(index: Int) {
        
        
        let cardID = self.paymentForms.paymentForm[index].id
        let lastDigits = self.paymentForms.paymentForm[index].digits
        let type = self.paymentForms.paymentForm[index].type
                
        // Here we gonna put the id of the card so I can use it in the new view.
        UserDefaults.standard.set(cardID, forKey: "cardIDValue")
        // And here we gonna put the last digits.
        UserDefaults.standard.set(lastDigits, forKey: "lastDigitsValue")
        // And the type of payment
        UserDefaults.standard.set(type, forKey: "typeOfCard")
        
        // Register Nib
        let newViewController = rechargeCreditViewController(nibName: "rechargeCreditViewController", bundle: nil)

        // Present View "Modally"
        self.present(newViewController, animated: true, completion: nil)
        
    }
}

extension PaymentFormsVC: AddCardDelegate {
  func didAddCard() {
    requestData()
    delegate.didChangePaymentForms()
    NotificationCenter.default.post(name: Notification.Name("reloadBalance"), object: nil)
  }
}
