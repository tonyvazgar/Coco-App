//
//  listOfStudentsViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 18/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField

class listOfStudentsViewController: UIViewController {
    
    let userID = UserManagement.shared.id_user
    let promo = Promo?.self
    var students : [Dictionary<String, Any>] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dropdown = DropDown()
    var idData: [String] = []
    var data: [String] = []
    var dataFiltered: [String] = []
    var dictionary: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = .white
        searchBar.tintColor = .CocoBlack
        requesData()
        searchBar.delegate = self
        dataFiltered = data
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureDropdown()
        searchBar.becomeFirstResponder()
    }
        
    private func requesData() {
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getUserMain&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("error: No data to decode")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject> {
                
                if let items = dictionary["data"] {

                    
                    if let alumnos = items["alumnos"] as? [Dictionary<String, Any>] {
                        
                        for d in alumnos {
                                                        
                            self.students.append(d)

                        }
                        
                        let contentArray = alumnos.compactMap { $0["nombre"] as? String }
                        self.data = contentArray
                        
                        let contentArray2 = alumnos.compactMap { $0["Id"] as? String}
                        self.idData = contentArray2
                        
                        
                    }
                    
                }
                
            }
            
            guard let promoInfo = try? JSONDecoder().decode(Promo.self, from: data) else {
                print("Error: Couldn't decode data into info")
                return
            }
            
        }
        
        task.resume()
            
    }
    
    private func configureDropdown() {
        dropdown.anchorView = searchBar
        dropdown.bottomOffset = CGPoint(x: 0, y: searchBar.bounds.height)
        dropdown.direction = .bottom
        dropdown.dataSource = data
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchBar.text = item
            let drinks = self.students.map({$0["nombre"]!})
            let drnks = self.students.map({$0["Id"]!})
            for (index, element) in drinks.enumerated() {
                self.dictionary[element as! String] = drnks[index] as! String
            }
            let ID: String? = self.dictionary[item]
            UserDefaults.standard.set(ID, forKey: "friendID")
            UserDefaults.standard.set(item, forKey: "friendName")
            NotificationCenter.default.post(name: Notification.Name("changedTheName"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func goAway(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension listOfStudentsViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        dropdown.show()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        dropdown.dataSource = dataFiltered
        dropdown.show()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dataFiltered = data
        dropdown.hide()
        self.dismiss(animated: true, completion: nil)
    }
    
}
