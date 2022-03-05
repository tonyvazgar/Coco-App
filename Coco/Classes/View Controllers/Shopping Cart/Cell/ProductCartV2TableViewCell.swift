//
//  ProductCartV2TableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 28/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

protocol ProductoCanastaDelegate {
    func aumentarCantidad(index : Int)
    func restarCantidad(index : Int)
}
class ProductCartV2TableViewCell: UITableViewCell {

    @IBOutlet weak var vistaImagen: UIView!
    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var vistaStepper: UIView!
    
    @IBOutlet weak var lblCantidad: UILabel!
    
    @IBOutlet weak var btnAumentar: UIButton!
    @IBOutlet weak var btnRestar: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    
    var delegate : ProductoCanastaDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProducto.layer.cornerRadius = 70/2
        vistaImagen.layer.cornerRadius = 70/2
        vistaStepper.layer.cornerRadius = 10
        
        
        
        vistaTarjeta.layer.cornerRadius = 20
        
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        vistaTarjeta.layer.shadowColor = gris.cgColor
        vistaTarjeta.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta.layer.shadowOpacity = 0.7
        vistaTarjeta.layer.shadowRadius = 15
        
        
        vistaImagen.layer.shadowColor = UIColor.gray.cgColor
        vistaImagen.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaImagen.layer.shadowOpacity = 0.5
        vistaImagen.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func aumentarAction(_ sender: UIButton) {
        delegate?.aumentarCantidad(index: sender.tag)
    }
    
    @IBAction func restarAction(_ sender: UIButton) {
        delegate?.restarCantidad(index: sender.tag)
    }
}
