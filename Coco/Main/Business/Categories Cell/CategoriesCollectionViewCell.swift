//
//  CategoriesCollectionViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var categoryLabel: UILabel!
  
  static let cellIdentifier = "CategoriesCollectionViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.layer.borderWidth = 0.5
    backView.layer.borderColor = UIColor.lightGray.cgColor
    backView.roundCorners(8, clipToBounds: false)
    categoryImage.roundCorners(8)
  }
}
