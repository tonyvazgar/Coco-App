//
//  PaymentFormsTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol PaymentFormCellDelegate {
  func didTapDeletePaymentForm(index: Int)
    func didChoseAPayment(index: Int)
}
class PaymentFormsTableViewCell: UITableViewCell {

  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var digitsLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var typeOfCard: UIImageView!
    
  static let cellIdentifier = "PaymentFormsTableViewCell"
  
  var delegate: PaymentFormCellDelegate!
  var index: Int = 0 {
    didSet {
      counterLabel.text = "\(index + 1)"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    counterLabel.circleBorders()
  }
    @IBAction func addBalance(_ sender: Any) {
        
        delegate.didChoseAPayment(index: index)
        
    }
    
  @IBAction func deleteAction(_ sender: Any) {
    delegate.didTapDeletePaymentForm(index: index)
  }
}
