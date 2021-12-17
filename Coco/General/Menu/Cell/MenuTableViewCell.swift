//
//  MenuTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  static let cellIdentifier = "MenuTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
