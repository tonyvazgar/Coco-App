//
//  ListaTarjetasViewController.swift
//  Coco
//
//  Created by Erick Monfil on 02/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ListaTarjetasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func agregarTarjetaAction(_ sender: UIButton) {
        let viewController = UIStoryboard.payments.instantiate(AgregarTarjetaViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
