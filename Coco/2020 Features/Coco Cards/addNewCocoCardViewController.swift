//
//  addNewCocoCardViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 26/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class addNewCocoCardViewController: UIViewController {
    
    @IBOutlet weak var cardNumberTF: UITextField!
    let userID = UserManagement.shared.id_user
    private var mainData: Main!
    private var balance: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addCard(_ sender: Any) {
        
        if cardNumberTF.text!.isEmpty {
            
            let alert = UIAlertController(title: "¡Error!", message: "Debes introducir un codigo", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        let url = URL(string: General.endpoint)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postString = "funcion=ChangeFolioCocoCard&id_user="+userID!+"&token="+cardNumberTF.text!
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(" \n\n Respuesta: ")
                print(" ============ ")
                print(json as Any)
                print(" ============ ")
                
                if let parseJSON = json {
                    
                    if let state = parseJSON["state"]{
                        
                        let stateString = "\(state)"
                        
                        if stateString == "600" {
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "Error", message: "No se pudo canjear el codigo.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Intentar otro", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                        }
                        
                        if stateString == "200" {
                            
                            DispatchQueue.main.async {
                                
                                NotificationCenter.default.post(name: Notification.Name("reloadBalance"), object: nil)
                                
                                let alert = UIAlertController(title: "¡Exito!", message: "Se ha recargado tu saldo.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Genial", style: .cancel, handler: { action in
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newCardReload"), object: nil)
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadBalance"), object: nil)
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        } else if stateString == "101" {
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "Error", message: "El codigo ya fue utilizado.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Volver a intentar o corregir.", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
                                print(stateString)
                                
                                let alert = UIAlertController(title: "Error", message: "Hay un problema con el servidor, inténtalo de nuevo más tarde.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
}
