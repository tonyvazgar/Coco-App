//
//  BusinessesCollectionViewCell.swift
//  Coco
//
//  Created by Tony Vazgar on 19/01/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class BusinessesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
//    categoryImage
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var midView: UIView!
    //    categoryLabel
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let cellIdentifier = "BusinessesCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        midView.roundCorners(20, clipToBounds: false)
        midView.layer.shadowColor = UIColor.black.cgColor
        midView.layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        midView.layer.shadowOpacity = 0.5
        
        categoryImage.layer.cornerRadius = (categoryImage.frame.size.width)/2
        categoryImage.clipsToBounds = true
        categoryImage.layer.masksToBounds = true
//        
//        let topShadow = EdgeShadowLayer(forView: categoryImage, edge: .Top)
//        categoryImage.layer.addSublayer(topShadow)
    }
}
