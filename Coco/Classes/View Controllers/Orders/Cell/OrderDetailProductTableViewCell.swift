//
//  OrderDetailProductTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class OrderDetailProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var total: UILabel!
    
    static let cellIdentifier = "OrderDetailProductTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
