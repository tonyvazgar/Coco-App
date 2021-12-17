//
//  BalanceTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {

  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var cardHolder: UILabel!
  @IBOutlet weak var digitsLabel: UILabel!
  @IBOutlet weak var typeView: UIImageView!
  
  static let cellIdentifier = "BalanceTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.setShadow()
    backView.roundCorners(8, clipToBounds: false)
    dateLabel.roundCorners(12)
  }
}
