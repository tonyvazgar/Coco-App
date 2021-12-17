//
//  SideMenuTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/7/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    static let cellIdentifier = "SideMenuTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
