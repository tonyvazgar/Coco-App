//
//  TarjetaOxxoTableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 05/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class TarjetaOxxoTableViewCell: UITableViewCell {

    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var lblSaldo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vistaTarjeta.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
