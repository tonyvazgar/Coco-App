//
//  DetallePedidoViewController.swift
//  Coco
//
//  Created by Erick Monfil on 28/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class DetallePedidoViewController: UIViewController {

    @IBOutlet weak var vistaRestaurante: UIView!
    @IBOutlet weak var vistaMetodoPago: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
