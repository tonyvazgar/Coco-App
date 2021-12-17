//
//  FavoriteProductTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol FavoriteProductCellDelegate: AnyObject {
    func didTapFavoriteAction(productId: String?)
}

final class FavoriteProductTableViewCell: UITableViewCell {
    @IBOutlet private var backView: UIView!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    static let cellIdentifier = "FavoriteProductTableViewCell"
    var productId: String?
    weak var delegate: FavoriteProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // corner radius
        backView.layer.cornerRadius = 8

        // border
        backView.layer.borderWidth = 0.5
        backView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = .zero
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowRadius = 2
        
        dishImage.roundCorners(8)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        delegate?.didTapFavoriteAction(productId: productId)
    }
}
