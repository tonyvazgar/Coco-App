//
//  BusinessesTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/8/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class BusinessesTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    
    static let cellIdentifier = "BusinessesTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // corner radius
        backView.layer.cornerRadius = 8
        businessImage.layer.cornerRadius = businessImage.frame.height/2

        // border
        backView.layer.borderWidth = 0.5
        backView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
//        backView.layer.shadowColor = UIColor.black.cgColor
//        backView.layer.shadowOffset = .zero
//        backView.layer.shadowOpacity = 0.25
//        backView.layer.shadowRadius = 2
    }
}
