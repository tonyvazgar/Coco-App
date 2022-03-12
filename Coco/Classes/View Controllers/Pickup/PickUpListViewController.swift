//
//  PickUpListViewController.swift
//  Coco
//
//  Created by Erick Monfil on 01/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class PickUpListViewController: UIViewController {

    @IBOutlet weak var vistaRestaurante: UIView!
    @IBOutlet weak var vistaAuto: UIView!
    @IBOutlet weak var vistaLugar: UIView!
    var location: LocationsDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        
        
        vistaRestaurante.layer.cornerRadius = 30
        vistaRestaurante.backgroundColor = .white
        vistaRestaurante.layer.shadowColor = gris.cgColor
        vistaRestaurante.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaRestaurante.layer.shadowOpacity = 0.7
        vistaRestaurante.layer.shadowRadius = 15
        
        vistaAuto.layer.cornerRadius = 30
        vistaAuto.backgroundColor = .white
        vistaAuto.layer.shadowColor = gris.cgColor
        vistaAuto.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaAuto.layer.shadowOpacity = 0.7
        vistaAuto.layer.shadowRadius = 15
        
        vistaLugar.layer.cornerRadius = 30
        vistaLugar.backgroundColor = .white
        vistaLugar.layer.shadowColor = gris.cgColor
        vistaLugar.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaLugar.layer.shadowOpacity = 0.7
        vistaLugar.layer.shadowRadius = 15
        
        let pickSttring = Constatns.LocalData.tipoPickUpAceptados
        let arrPickups = pickSttring.components(separatedBy: ",")
        
        vistaRestaurante.visibility = .gone
        vistaAuto.visibility = .gone
        vistaLugar.visibility = .gone
        for item in arrPickups{
            if item == "1" {
                vistaRestaurante.visibility = .visible
            }
            if item == "2" {
                vistaAuto.visibility = .visible
            }
            if item == "3" {
                vistaLugar.visibility = .visible
            }
        }
        
    }
    
   

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restauranteAction(_ sender: UIButton) {
        let viewController = UIStoryboard.pickups.instantiate(RestaurantePickupViewController.self)
        viewController.location = self.location
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func autoAction(_ sender: UIButton) {
        let viewController = UIStoryboard.pickups.instantiate(AutoPickupViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func lugarAction(_ sender: UIButton) {
        let viewController = UIStoryboard.pickups.instantiate(LugarPickupViewController.self)
        viewController.location = self.location
        navigationController?.pushViewController(viewController, animated: true)
    }
}
