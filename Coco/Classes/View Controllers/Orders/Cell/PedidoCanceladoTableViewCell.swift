//
//  PedidoCanceladoTableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 11/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class PedidoCanceladoTableViewCell: UITableViewCell {

    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var vistaImagen: UIView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblNombreStore: UILabel!
    @IBOutlet weak var lblCodigo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        
        vistaTarjeta.layer.cornerRadius = 30
        vistaTarjeta.backgroundColor = .white
        vistaTarjeta.layer.shadowColor = gris.cgColor
        vistaTarjeta.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta.layer.shadowOpacity = 0.7
        vistaTarjeta.layer.shadowRadius = 15
        
        vistaImagen.layer.cornerRadius = 94/2
        imgStore.layer.cornerRadius = 94/2
        vistaImagen.layer.shadowColor = UIColor.gray.cgColor
        vistaImagen.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaImagen.layer.shadowOpacity = 0.5
        vistaImagen.layer.shadowRadius = 3
    }
    
}
