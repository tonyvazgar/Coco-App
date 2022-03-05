//
//  AutoPickupViewController.swift
//  Coco
//
//  Created by Erick Monfil on 01/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class AutoPickupViewController: UIViewController {

    @IBOutlet weak var btnConfirmar: UIButton!
    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var vistaHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnConfirmar.layer.cornerRadius = 20
        
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
        
        
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
