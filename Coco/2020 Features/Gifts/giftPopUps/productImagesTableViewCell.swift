//
//  productImagesTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 23/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class productImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
