//
//  DepositsTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class DepositsTableViewCell: UITableViewCell {
    
    @IBOutlet var backView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var cardHolder: UILabel!
    @IBOutlet var digitsLabel: UILabel!
    @IBOutlet var typeView: UIImageView!
    
    static let cellIdentifier = "DepositsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.setShadow()
        backView.roundCorners(8, clipToBounds: false)
        dateLabel.roundCorners(10)
    }
}
