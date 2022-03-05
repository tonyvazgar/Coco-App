//
//  AgregarTarjetaViewController.swift
//  Coco
//
//  Created by Erick Monfil on 02/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import AnimatedCardInput

class AgregarTarjetaViewController: UIViewController, CreditCardDataDelegate {
    func beganEditing(in textFieldType: TextFieldType) {
        
    }
    
    func cardNumberChanged(_ number: String) {
        
    }
    
    func cardholderNameChanged(_ name: String) {
        
    }
    
    func validityDateChanged(_ date: String) {
        
    }
    
    func CVVNumberChanged(_ cvv: String) {
        
    }
    

    @IBOutlet weak var vistaTarjeta: UIView!
    
    @IBOutlet weak var btnRegistrar: UIButton!
    
    var cardView : CardView?
    var loader: LoaderVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegistrar.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        cardView = CardView(
            cardNumberDigitsLimit: 16,
            cardNumberChunkLengths: [4, 4, 4, 4],
            CVVNumberDigitsLimit: 3
        )
        
        cardView!.cardholderNameTitle = "Nombre"
        cardView!.cardholderNamePlaceholder = "Nombre completo"
        cardView!.validityDateTitle = "Fecha"
        vistaTarjeta.addSubview(cardView!)
        cardView!.creditCardDataDelegate = self
        NSLayoutConstraint.activate([
                    cardView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                    cardView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    cardView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

                   
                ])
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registrarTarjetaActipn(_ sender: UIButton) {
        let data = cardView!.creditCardData
        print("Nombre proveedor: \(data.cardProvider?.name ?? "")")
        print("numero: \(data.cardNumber)")
        print("nombre: \(data.cardholderName)")
        print("Fecha: \(data.validityDate)")
        print("cvv: \(data.CVVNumber)")
        
        let proveedor : String = data.cardProvider?.name ?? ""
        let numeroTarjeta : String = data.cardNumber
        let nombreTarjeta : String = data.cardholderName
        let fecha : String = data.validityDate
        let cvv : String = data.CVVNumber
        
        if proveedor.isEmpty {
            throwError(str: "La tarjeta no es valida")
            return
        }
        
        
        if numeroTarjeta.isEmpty {
            throwError(str: "La tarjeta no es valida")
            return
        }
        
        if nombreTarjeta.isEmpty {
            throwError(str: "Escribe el nombre de la tarjeta")
            return
        }
        
        if nombreTarjeta.isEmpty {
            throwError(str: "Escribe el nombre de la tarjeta")
            return
        }
        
        if fecha.isEmpty {
            throwError(str: "La fecha de expiración no es valida")
            return
        }
        
        if cvv.isEmpty {
            throwError(str: "Escribe el CVV")
            return
        }
        
        let array = fecha.components(separatedBy: "/")
        var mes : String = ""
        var ano : String = ""
        
        if array.count == 2 {
            mes = array[0]
            ano = "20\(array[1])"
        }
        else {
            throwError(str: "La fecha de expiración no es valida")
            return
        }
        
        
        
        let conekta = Conekta()
        
        conekta.delegate = self
        conekta.publicKey = "key_CLYZkCgpss3hHwqp1k5XfCw"
        conekta.collectDevice()
        guard let card = conekta.card(), let token = conekta.token() else {
          throwError(str: "No se pudo procesar la tarjeta.")
          return
        }
        showLoader(&loader, view: view)
        card.setNumber(numeroTarjeta, name: nombreTarjeta, cvc: cvv, expMonth: mes, expYear: ano)
        token.card = card
        
        token.create(success: { (data) -> Void in
            
        print(data)
          guard let dataCard = data,
            let id = dataCard["id"] else {
                print(data)
              self.loader.removeAnimate()
              self.throwError(str: "No se pudo procesar la tarjeta")
              return
          }
          let type = proveedor
          
          let newCard = Cards(name: nombreTarjeta, address: "ddfsdf", second_address: "sdfsd", zip: "2222", number: "22222222", digits: String(numeroTarjeta.suffix(4)), type: type, token: "\(id)", auto: "0", amount: "0")
          
            Constatns.LocalData.tokenTarjeta = "\(id)"
            self.navigationController?.popViewController(animated: true)
            
            
            /*
          newCard.addCard(completion: { (result) in
            switch result {
            case .failure(let errorMssg):
              self.loader.removeAnimate()
              self.throwError(str: errorMssg)
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            }
          })
            
            */
            
        }, andError: { (error) -> Void in
            print(error)
          self.loader.removeAnimate()
          self.throwError(str: "Ocurrió un error al procesar la tarjeta")
        })
    }
    
}

extension AgregarTarjetaViewController  {
    
    
}
