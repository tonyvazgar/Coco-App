//
//  LugarPickupViewController.swift
//  Coco
//
//  Created by Erick Monfil on 01/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class LugarPickupViewController: UIViewController {

    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var vistaHeader: UIView!
    @IBOutlet weak var btnConfirmar: UIButton!
    @IBOutlet weak var vistaProducto: UIView!
    @IBOutlet weak var imgProducto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        
        
        vistaTarjeta.layer.cornerRadius = 30
        vistaTarjeta.backgroundColor = .white
        vistaTarjeta.layer.shadowColor = gris.cgColor
        vistaTarjeta.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta.layer.shadowOpacity = 0.7
        vistaTarjeta.layer.shadowRadius = 15
        
        vistaHeader.layer.cornerRadius = 30
        vistaHeader.backgroundColor = .white
        vistaHeader.layer.shadowColor = gris.cgColor
        vistaHeader.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaHeader.layer.shadowOpacity = 0.7
        vistaHeader.layer.shadowRadius = 15
        
        vistaProducto.layer.cornerRadius = 94/2
        imgProducto.layer.cornerRadius = 94/2
        vistaProducto.layer.shadowColor = UIColor.gray.cgColor
        vistaProducto.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaProducto.layer.shadowOpacity = 0.5
        vistaProducto.layer.shadowRadius = 3
        
        btnConfirmar.layer.cornerRadius = 20
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
