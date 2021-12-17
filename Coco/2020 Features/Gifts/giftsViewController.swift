//
//  giftsViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 16/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class giftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, showMeTheGiftDetail {
    
    @IBOutlet weak var table: UITableView!
    
    var gifts : [Dictionary<String, Any>] = []
    let userID = UserManagement.shared.id_user
    let reuseDocument = "DocumentCellCards"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        getThemGifts()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: "refreshTheList"), object: nil)
    }
    
    func showTheDetail(idNumber:String, orderStatus:String) {
        let myViewController = giftDetailViewController(nibName: "giftDetailViewController", bundle: nil)
        myViewController.orderNumber = idNumber
        myViewController.giftStatus = orderStatus
        self.present(myViewController, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        gifts.removeAll()
        getThemGifts()
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if gifts.count < 0 {
//            tableView.isHidden = true
//            return 0
//        }
        return gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = gifts[indexPath.row]
        let date = document["fecha"] as! String
        let status = document["estatus"] as! String
        let orden = document["Id"] as! String
        let businessName = document["nombre"] as! String
        let friend = document["amigo"] as! String
        let estatusRegalo = document["estatus_regalo"] as! String
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
        if let cell = cell as? giftsTableViewCell {
            cell.delegate = self
            DispatchQueue.main.async {
                if status == "Pagado" && estatusRegalo == "Cerrado" {
                    cell.underGiftButton.backgroundColor = UIColor.CocoGreen
                    cell.underGiftButton.setTitleColor(UIColor.white, for: .normal)
                    cell.underGiftButton.isUserInteractionEnabled = true
                    cell.detailsButton.isUserInteractionEnabled = false
                    cell.detailsButton.isHidden = true
                    cell.detailsLabel.isHidden = true
                    cell.underGiftButton.setTitle("¡Abrir Regalo!", for: .normal)
                }
                
                if status == "Pagado" && estatusRegalo == "Abierto" {
                    cell.underGiftButton.backgroundColor = UIColor.white
                    cell.underGiftButton.setTitleColor(UIColor.black, for: .normal)
                    cell.underGiftButton.isUserInteractionEnabled = false
                    cell.detailsButton.isUserInteractionEnabled = true
                    cell.detailsButton.isHidden = false
                    cell.detailsLabel.isHidden = false
                    cell.underGiftButton.setTitle("Regalo abierto", for: .normal)
                }
                
                if status == "Canjeado" {
                    cell.underGiftButton.backgroundColor = UIColor.white
                    cell.underGiftButton.setTitleColor(UIColor.black, for: .normal)
                    cell.underGiftButton.isUserInteractionEnabled = false
                    cell.detailsButton.isUserInteractionEnabled = true
                    cell.detailsButton.isHidden = false
                    cell.detailsLabel.isHidden = false
                    cell.underGiftButton.setTitle("Regalo abierto", for: .normal)
                }
                
                if status == "Entregado" {
                    cell.underGiftButton.backgroundColor = UIColor.white
                    cell.underGiftButton.setTitleColor(UIColor.black, for: .normal)
                    cell.underGiftButton.isUserInteractionEnabled = false
                    cell.detailsButton.isUserInteractionEnabled = true
                    cell.detailsButton.isHidden = false
                    cell.underGiftButton.setTitle("Regalo abierto", for: .normal)
                }
                cell.dateOrder.text = "Fecha: \(date)"
                cell.statusOrder.text = "Estatus: \(status)"
                cell.orderName.text = orden
                cell.friendOrder.text = "Amigo: " + friend
                cell.storeOrder.text = "Cafetería: " + businessName
                let ordenNumber = Int(orden)
                cell.underGiftButton.tag = ordenNumber!
                cell.detailsButton.tag = ordenNumber!
                cell.giftStatus = estatusRegalo
                print(estatusRegalo)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    private func configureTable() {
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let documentXib = UINib(nibName: "giftsTableViewCell", bundle: nil)
        table.register(documentXib, forCellReuseIdentifier: reuseDocument)
    }
    
    func getThemGifts() {
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getPresent&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                    for d in items {
                        self.gifts.append(d)
                    }
                }
            }
            
            DispatchQueue.main.async {
                if self.gifts.count > 0 {
                    self.table.reloadData()
                }
            }
        }.resume()
    }
    
    @IBAction func close(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("stopShaking"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
