//
//  CategoryCollectionViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let cellIdentifier = "CategoryCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.borderWidth = 1.5
        backView.backgroundColor = .white
        backView.layer.borderColor = UIColor.cocoGrayBorder.cgColor
        backView.roundCorners(8, clipToBounds: false)
        categoryImage.roundCorners(8)
    }
}
