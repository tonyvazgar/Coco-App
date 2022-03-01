//
//  ShoppingCartV2ViewController.swift
//  Coco
//
//  Created by Erick Monfil on 28/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ShoppingCartV2ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vistaNegocio: UIView!
    @IBOutlet weak var imgNegocio: UIImageView!
    @IBOutlet weak var btnPagar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgNegocio.layer.cornerRadius = 94/2
        vistaNegocio.layer.cornerRadius = 94/2
        btnPagar.layer.cornerRadius = 20
        
        vistaNegocio.layer.shadowColor = UIColor.gray.cgColor
        vistaNegocio.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaNegocio.layer.shadowOpacity = 0.5
        vistaNegocio.layer.shadowRadius = 3
        
        tableView.register(UINib(nibName: "ProductCartV2TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pagarAction(_ sender: UIButton) {
        let viewController = UIStoryboard.shoppingCart.instantiate(DetallePedidoViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ShoppingCartV2ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCartV2TableViewCell
        return cell
    }
    
    
}
