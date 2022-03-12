//
//  PedidoListoTableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 08/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

protocol PedidoListoDelegate{
    func comoLLegarListo(index : Int)
    func yaLLegueListo(index : Int)
}
class PedidoListoTableViewCell: UITableViewCell {

    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var vistaTop: UIView!
    @IBOutlet weak var vistaImagen: UIView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblNombreStore: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnOCmoLLegar: UIButton!
    @IBOutlet weak var btnYaLLegue: UIButton!
    @IBOutlet weak var lblCodigo: UILabel!
    @IBOutlet weak var btnComoLLegarGrande: UIButton!
    
    var delegate : PedidoListoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        btnOCmoLLegar.layer.cornerRadius = 20
        btnYaLLegue.layer.cornerRadius = 20
        vistaTarjeta.layer.cornerRadius = 30
        vistaTarjeta.backgroundColor = .white
        vistaTarjeta.layer.shadowColor = gris.cgColor
        vistaTarjeta.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta.layer.shadowOpacity = 0.7
        vistaTarjeta.layer.shadowRadius = 15
        
        
        vistaTop.layer.cornerRadius = 30
        vistaTop.backgroundColor = .white
        vistaTop.layer.shadowColor = gris.cgColor
        vistaTop.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTop.layer.shadowOpacity = 0.7
        vistaTop.layer.shadowRadius = 15
        
        
        vistaImagen.layer.cornerRadius = 94/2
        imgStore.layer.cornerRadius = 94/2
        vistaImagen.layer.shadowColor = UIColor.gray.cgColor
        vistaImagen.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaImagen.layer.shadowOpacity = 0.5
        vistaImagen.layer.shadowRadius = 3
        btnComoLLegarGrande.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func comoLlegarListoDelegate(_ sender: UIButton) {
        delegate?.comoLLegarListo(index: sender.tag)
    }
    
    @IBAction func yaLLegueListoDelegate(_ sender: UIButton) {
        delegate?.yaLLegueListo(index: sender.tag)
    }
    @IBAction func comoLlegarGrandeAction(_ sender: UIButton) {
        delegate?.comoLLegarListo(index: sender.tag)
    }
}
