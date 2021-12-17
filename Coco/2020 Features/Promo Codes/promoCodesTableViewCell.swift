//
//  promoCodesTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 26/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class promoCodesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var montoLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var codigoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        codigoLabel.clipsToBounds = true
        codigoLabel.layer.cornerRadius = 15
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
