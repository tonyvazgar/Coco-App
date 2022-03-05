//
//  ListaPedidosViewController.swift
//  Coco
//
//  Created by Erick Monfil on 05/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ListaPedidosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "PedidoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CellOk")
    }
    


}

extension ListaPedidosViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOk", for: indexPath) as! PedidoItemTableViewCell
        return cell
    }
    
    
}
