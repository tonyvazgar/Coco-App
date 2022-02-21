//
//  LocationsTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class LocationsTableViewCell: UITableViewCell {
    @IBOutlet var backView: UIView!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var locationName: UILabel!
    @IBOutlet var locationDistanceLabel: UILabel!
    @IBOutlet var locationScheduleLabel: UILabel!
    @IBOutlet var locationRatingLabel: UILabel!
    
    static let cellIdentifier = "LocationsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // corner radius
        backView.layer.cornerRadius = 18

        // border
        backView.layer.borderWidth = 0
        backView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.layer.shadowOffset = CGSize(width: 5, height: 5)
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowRadius = 50
    }
}
