//
//  ProductV2TableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 23/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ProductV2TableViewCell: UITableViewCell {

    @IBOutlet weak var vistaTarjeta: UIView!
    
    @IBOutlet weak var vistaTarjeta2: UIView!
    
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vistaLogo: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vistaTarjeta.backgroundColor = .white
        vistaTarjeta.layer.cornerRadius = 30
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        vistaTarjeta.layer.shadowColor = gris.cgColor
        vistaTarjeta.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta.layer.shadowOpacity = 0.9
        vistaTarjeta.layer.shadowRadius = 15
        
        
        vistaTarjeta2.backgroundColor = .white
        vistaTarjeta2.layer.cornerRadius = 30
        vistaTarjeta2.layer.shadowColor = gris.cgColor
        vistaTarjeta2.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta2.layer.shadowOpacity = 0.9
        vistaTarjeta2.layer.shadowRadius = 15
        
        vistaLogo.layer.shadowColor = UIColor.gray.cgColor
        vistaLogo.layer.shadowOffset = CGSize(width: 0, height: 6)
        vistaLogo.layer.shadowOpacity = 0.4
        vistaLogo.layer.shadowRadius = 6
        
        vistaLogo.layer.cornerRadius = vistaLogo.frame.size.width / 2
        imgLogo.layer.cornerRadius = vistaLogo.frame.size.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
