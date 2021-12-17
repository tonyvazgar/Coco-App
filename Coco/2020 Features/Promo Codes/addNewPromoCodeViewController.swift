//
//  addNewPromoCodeViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 26/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class addNewPromoCodeViewController: UIViewController {
    
    var main : MainController?
    private var mainData: Main!
    
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var codeField: UITextField!
    let userID = UserManagement.shared.id_user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setupView() {
        
        useButton.roundCorners(15)
        useButton.text("UTILIZAR")
    }
    
    
    @IBAction func useCode(_ sender: Any) {
        
        
        if codeField.text!.isEmpty {
            
            let alert = UIAlertController(title: "¡Error!", message: "Debes introducir un codigo", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        let url = URL(string: General.endpoint)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        
        let postString = "funcion=ChangeCodePromotional&id_user="+userID!+"&token="+codeField.text!
        
        print(postString)
        
        request.httpBody = postString.data(using: .utf8) // SE codifica a UTF-8
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Validacion para errores de Red
            
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
                                
                                let alert = UIAlertController(title: "Error", message: "Ya usaste este codigo.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Intentar otro.", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                                
                            }
                        }
                        
                        if stateString == "200" {
                            
                            NotificationCenter.default.post(name: Notification.Name("reloadBalance"), object: nil)
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "¡Exito!", message: "Se ha canjeado el código exitosamente.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Genial", style: .cancel, handler: { action in
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newCodeReload"), object: nil)
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    
                                }))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        } else if stateString == "101" {
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "Error", message: "El codigo no existe.", preferredStyle: .alert)
                                
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
