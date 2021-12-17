//
//  ShoppingCartProductCellTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/17/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol ShoppingCartProductCellDelegate {
  func didTapDelete(index: Int)
}

class ShoppingCartProductCellTableViewCell: UITableViewCell {
  
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var quantity: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var total: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  
  var index: Int = 0
  var delegate: ShoppingCartProductCellDelegate!
  
  static let cellIdentifier = "ShoppingCartProductCellTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @IBAction func deleteAction(_ sender: Any) {
    delegate.didTapDelete(index: index)
  }
}
