//
//  storedCardsViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 26/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import Hero

class storedCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let reuseDocument = "DocumentCellCards"
    let userID = UserManagement.shared.id_user
    var cards : [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getThemCards()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newCard), name: Notification.Name(rawValue: "newCardReload"), object: nil)
        
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        let documentXib = UINib(nibName: "cardsTableViewCell", bundle: nil)
        tableView.register(documentXib, forCellReuseIdentifier: reuseDocument)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cards.count < 0 {
            
            tableView.isHidden = true
            
            return 0
            
        }
        
        return cards.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = cards[indexPath.row]
        
        let amount = document["monto"] as! String
        let date = document["fecha"] as! String
        let token = document["token"] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? cardsTableViewCell {
            
            DispatchQueue.main.async {
                
                cell.fechaLabel.text = date
                cell.folioLabel.text = token
                cell.moneyAmountLavel.text = "$\(amount)"
                
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    @objc func newCard() {
        
        cards.removeAll()
        getThemCards()
        DispatchQueue.main.async { self.tableView.reloadData() }
        
    }
    
    func getThemCards() {
        
        print("Downloading cards")
        
        let url = URL(string: General.endpoint)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getCocoCards&id_user="+userID!
        print(userID!)
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print(dictionary)
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.cards.append(d)
                            
                            print("Appended cards")
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if self.cards.count > 0 {
                        self.tableView.reloadData()
                        print("Tableview was reloaded")
                    }
                    
                }
                
            }
            
        }.resume()
        
        
    }
    
    @IBAction func addNewCard(_ sender: Any) {
        
        let addCardVC = addNewCocoCardViewController(nibName: "addNewCocoCardViewController", bundle: nil)
        self.present(addCardVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func closeView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
