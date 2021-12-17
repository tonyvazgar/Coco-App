//
//  OrderTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol showMeTheCoco {
    func showsTheCoco(position: UIView)
}

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var montoCocoLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    var delegate : showMeTheCoco!
    
    static let cellIdentifier = "OrderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.setShadow()
        backView.roundCorners(8, clipToBounds: false)
        orderNumber.roundCorners(12)
        
        detailLabel.roundCorners(8)
    }
}
