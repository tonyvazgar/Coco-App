//
//  ProductsTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var dishImage: UIImageView!
  @IBOutlet weak var dishName: UILabel!
  @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cocopointsCost: UILabel!
    
  static let cellIdentifier = "ProductsTableViewCell"
  let index: Int = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.setShadow()
    backView.roundCorners(8, clipToBounds: false)
    dishImage.roundCorners(8)
  }
}
