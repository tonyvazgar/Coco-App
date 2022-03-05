//
//  ProductCheckBoxTableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 24/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit


protocol OpcionProductDelegate {
    func seleccionoOpcion(index : Int, status : Bool, seccion : Int)
}

class ProductCheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var vistaCheck: UIView!
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var lblTitulo: UILabel!
    var seccionSeleccionado :Int = 0
    var delegate : OpcionProductDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vistaCheck.layer.shadowColor = UIColor.gray.cgColor
        vistaCheck.layer.shadowOffset = CGSize(width: 0, height: 3)
        vistaCheck.layer.shadowOpacity = 0.4
        vistaCheck.layer.shadowRadius = 2
        checkBox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        print("checkbox value change: \(sender.isChecked)")
        delegate?.seleccionoOpcion(index: sender.tag, status: sender.isChecked,seccion: self.seccionSeleccionado)
    }
    
    
}
