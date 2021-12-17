//
//  BusinessTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var businessImage: UIImageView!
  @IBOutlet weak var businessName: UILabel!
  @IBOutlet weak var businessAddress: UILabel!
  @IBOutlet weak var businessSchedule: UILabel!
  
  static let cellIdentifier = "BusinessTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.layer.borderWidth = 0.5
      backView.layer.borderColor = UIColor.lightGray.cgColor
    backView.roundCorners(8, clipToBounds: false)
    businessImage.roundCorners(5)
  }
}
