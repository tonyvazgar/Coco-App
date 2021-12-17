//
//  FavoritesTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol FavoriteCellDelegate {
  func didTapFavoriteAction(index: Int)
}

class FavoritesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var dishImage: UIImageView!
  @IBOutlet weak var dishName: UILabel!
  @IBOutlet weak var brandName: UILabel!
  @IBOutlet weak var btnFavorite: UIButton!
  
  static let cellIdentifier = "FavoritesTableViewCell"
  let index: Int = 0
  var delegate: FavoriteCellDelegate!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.setShadow()
    backView.roundCorners(8, clipToBounds: false)
    dishImage.roundCorners(5)
  }
  
  @IBAction func favoriteAction(_ sender: Any) {
    delegate.didTapFavoriteAction(index: index)
  }
}
