//
//  OrderProductTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/19/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class OrderProductTableViewCell: UITableViewCell {
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var quantity: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var total: UILabel!
  
  var index: Int = 0
  
  static let cellIdentifier = "OrderProductTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
