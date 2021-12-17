//
//  cardsTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 26/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class cardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var moneyAmountLavel: UILabel!
    @IBOutlet weak var folioLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fechaLabel.clipsToBounds = true
        fechaLabel.roundCorners(15)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
