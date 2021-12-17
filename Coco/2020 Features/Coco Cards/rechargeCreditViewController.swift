//
//  rechargeCreditViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 2/5/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class rechargeCreditViewController: UIViewController {
    @IBOutlet private var cardNumbers: UITextField!
    @IBOutlet private var rechargeAmount: UITextField!
    @IBOutlet private var cardImage: UIImageView!
    @IBOutlet private var addCardButton: UIButton!
    
    var loader = LoaderVC()
    
    let userID = UserManagement.shared.id_user
    var cardID: String?
    var digits: String?
    var typeOfCard: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5) {
            self.cardImage.alpha = 1
        }
    }
    
    func configureView() {
        addCardButton.roundCorners(addCardButton.frame.height/2)
        cardNumbers.clipsToBounds = true
        rechargeAmount.clipsToBounds = true
        
        cardNumbers.addBottomBorder(thickness: 1, color: .lightGray)
        rechargeAmount.addBottomBorder(thickness: 1, color: .lightGray)
        
        cardImage.alpha = 0
        
        cardNumbers.isUserInteractionEnabled = false
        cardNumbers.text! = "**** **** **** \(digits ?? "****")"
        cardNumbers.textAlignment = .center
        rechargeAmount.textAlignment = .center
        
        if typeOfCard == "VISA" {
            
            cardImage.image = UIImage(named: "visa_sola")
            
        }
        
        if typeOfCard == "MASTER CARD" {
            
            cardImage.image = UIImage(named: "mastercard")
            
        }
        
        if typeOfCard == "AMEX" {
            
            cardImage.image = UIImage(named: "amex")
            
        }
        
    }
    
    @IBAction
    private func cancelRecharge(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rechargeButton(_ sender: Any) {
        guard let amount = rechargeAmount.text, !amount.isEmpty else {
            throwError(str: "Debes introducir una cantidad a recargar. 💵")
            return
            
        }
        if  Int(rechargeAmount.text!)! < 200 {
            throwError(str: "El monto a recargar no puede ser menor a $ 200")
            return
        }
        
        let data = [
            "funcion": "rechargeBalance",
            "id_user": UserManagement.shared.id_user!,
            "amount": amount,
            "id_token": cardID!
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { [weak self] (response) in
            guard let data = response.result.value else {
                self?.throwError(str: FetcherErrors.invalidResponse.localizedDescription)
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                self?.throwError(str: FetcherErrors.jsonMapping.localizedDescription)
                return
            }
            
            guard dictionary["state"] == "200" else {
                let error: String?
                if dictionary["state"] == "500" {
                    error = "Hemos encontrado un error. Intenta en unos minutos o verifica tener el saldo suficiente en tu tarjeta."
                } else {
                    error = dictionary["status_msg"]?.string
                }
                self?.throwError(str: FetcherErrors.statusCode(error).localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("reloadBalance"), object: nil)
                let alert = UIAlertController(title: "¡Exito!", message: "Hemos recargado la cantidad solicitada a tu saldo. ¡A comer!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Genial", style: .cancel) { action in
                    self?.navigationController?.popToRootViewController(animated: true)
                })
                self?.present(alert, animated: true)
            }
        }
    }
}

