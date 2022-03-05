//
//  ProductStepperTableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 24/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit


protocol ExtrasDelegate {
    func seleccionoExtras(seccion : Int, index : Int, cantidad : Int)
}
class ProductStepperTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var vistaStepper: UIView!
    @IBOutlet weak var vistaMas: UIView!
    @IBOutlet weak var anchoStepper: NSLayoutConstraint!//89
    @IBOutlet weak var anchoMas: NSLayoutConstraint!//30
    var cantidad : Int = 0
    
    @IBOutlet weak var btnResta: UIButton!
    @IBOutlet weak var btnSuma: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblTitulo: UILabel!
    var delegate : ExtrasDelegate?
    var seccionSeleccionada : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vistaStepper.visibility = .gone
        vistaStepper.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func mostrarStepperAction(_ sender: UIButton) {
        vistaStepper.visibility = .visible
        vistaMas.visibility = .gone
        cantidad = 1
        lblCantidad.text = "\(cantidad)"
        anchoMas.constant = 0
        anchoStepper.constant = 89
        self.delegate?.seleccionoExtras(seccion: seccionSeleccionada, index: sender.tag, cantidad: cantidad)
    }
    
    @IBAction func aumentarAction(_ sender: UIButton) {
        if cantidad < 11 {
            cantidad = cantidad + 1
            lblCantidad.text = "\(cantidad)"
        }
        self.delegate?.seleccionoExtras(seccion: seccionSeleccionada, index: sender.tag, cantidad: cantidad)
        
        
    }
    
    @IBAction func disminuyeAction(_ sender: UIButton) {
        if cantidad > 1 {
            cantidad = cantidad - 1
            lblCantidad.text = "\(cantidad)"
        }
        else {
            vistaStepper.visibility = .gone
            vistaMas.visibility = .visible
            cantidad = 0
            lblCantidad.text = "\(cantidad)"
            anchoMas.constant = 30
            anchoStepper.constant = 0
        }
        self.delegate?.seleccionoExtras(seccion: seccionSeleccionada, index: sender.tag, cantidad: cantidad)
    }
}