//
//  giftDetailImagesTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 22/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class giftDetailImagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameOfProduct: UILabel!
    
    static let cellIdentifier = "giftDetailImagesTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
