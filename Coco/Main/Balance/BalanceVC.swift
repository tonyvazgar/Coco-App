//
//  BalanceVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol BalanceDelegate {
  func didChangeBalance()
}

class BalanceVC: UIViewController {
  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var paymentFormsBtn: UIButton!
  
  var loader: LoaderVC!
  var deposits: Deposits!
  var delegate: BalanceDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    deposits = Deposits()
    configureView()
    configureTable()
    requestData()
  }
  
  private func configureView() {
    paymentFormsBtn.roundCorners(16)
  }
  
  private func configureTable() {
    table.separatorStyle = .none
    table.delegate = self
    table.dataSource = self
    table.tableFooterView = UIView()
    let nib = UINib(nibName: BalanceTableViewCell.cellIdentifier, bundle: nil)
    table.register(nib, forCellReuseIdentifier: BalanceTableViewCell.cellIdentifier)
  }
  
  private func requestData() {
    showLoader(&loader, view: view)
    deposits.requestDeposits { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.fillInfo()
      }
    }
  }
  
  private func fillInfo() {
    table.reloadData()
  }
  
  @IBAction func paymentFormsAction(_ sender: Any) {
    let vc = PaymentFormsVC()
    vc.delegate = self
    present(vc, animated: true)
  }
  
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

extension BalanceVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deposits.deposits.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.cellIdentifier, for: indexPath) as? BalanceTableViewCell else {
      return UITableViewCell()
    }
    let item = deposits.deposits[indexPath.row]
    cell.cardHolder.text = item.cardHolder
    cell.dateLabel.text = item.date
    cell.digitsLabel.text = item.digits
    cell.amountLabel.text = item.amount
    switch item.type {
    case "VISA":
      cell.typeView.image = #imageLiteral(resourceName: "visa_sola")
    case "MASTER CARD":
      cell.typeView.image = #imageLiteral(resourceName: "mastercard")
    case "AMEX":
      cell.typeView.image = #imageLiteral(resourceName: "amex")
    default:
      cell.typeView.image = #imageLiteral(resourceName: "credit_menu")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 202
  }
}

extension BalanceVC: PaymentFormsDelegate {
  func didChangePaymentForms() {
    requestData()
    delegate.didChangeBalance()
  }
}
