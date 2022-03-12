//
//  AgregarTarjetaViewController.swift
//  Coco
//
//  Created by Erick Monfil on 02/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import AnimatedCardInput
import Alamofire
import SwiftyJSON
class AgregarTarjetaViewController: UIViewController, CreditCardDataDelegate {
    func beganEditing(in textFieldType: TextFieldType) {
        print("beganEditing")
    }
    
    func cardNumberChanged(_ number: String) {
        print("cardNumberChanged")
    }
    
    func cardholderNameChanged(_ name: String) {
        print("cardholderNameChanged")
    }
    
    func validityDateChanged(_ date: String) {
        print("validityDateChanged")
    }
    
    func CVVNumberChanged(_ cvv: String) {
        print("CVVNumberChanged")
    }
    
    
    

    @IBOutlet weak var vistaTarjeta: UIView!
    
    @IBOutlet weak var btnRegistrar: UIButton!
    
    var cardView : CardView?
    var loader: LoaderVC!
    var isFromOrder : Bool = false
    
    
    private let inputsView: CardInputsView = {
            let view = CardInputsView(cardNumberDigitLimit: 16)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isSecureInput = true
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegistrar.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        cardView = CardView(
            cardNumberDigitsLimit: 16,
            cardNumberChunkLengths: [4, 4, 4, 4],
            CVVNumberDigitsLimit: 4
        )
        
        cardView!.cardholderNameTitle = "Nombre"
        cardView!.cardholderNamePlaceholder = "Nombre completo"
        cardView!.validityDateTitle = "Fecha"
        //cardView!.CVVNumberEmptyCharacter
        vistaTarjeta.addSubview(cardView!)
        
        NSLayoutConstraint.activate([
                    cardView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
                    cardView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    cardView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

                   
                ])
        
        
        self.view.addSubview(inputsView)
        
        NSLayoutConstraint.activate([
                   

            inputsView.topAnchor.constraint(equalTo: vistaTarjeta!.bottomAnchor, constant: 24),
            inputsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

                  
               ])
        cardView!.creditCardDataDelegate = inputsView
        inputsView.creditCardDataDelegate = cardView!
        inputsView.cardNumberTitle = "Número tarjeta"
        inputsView.cardholderNameTitle = "Nombre"
        inputsView.validityDateTitle = "Fecha"
        inputsView.cvvNumberTitle = "CVV"
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardView!.currentInput = .cardNumber
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
        conekta.publicKey = Constatns.Conekta.publickKeyProductive
        conekta.collectDevice()
        guard let card = conekta.card(), let token = conekta.token() else {
          throwError(str: "No se pudo procesar la tarjeta.")
          return
        }
        showLoader(&loader, view: view)
        card.setNumber(numeroTarjeta, name: nombreTarjeta, cvc: cvv, expMonth: mes, expYear: ano)
        token.card = card
        
        token.create(success: { [self] (data) -> Void in
            
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
          
            
            
            
            
            
            
            if isFromOrder == true {
                Constatns.LocalData.paymentCanasta.tipoTarjeta = type
                //Nuevatarjeta
                Constatns.LocalData.paymentCanasta.forma_pago = 2
                Constatns.LocalData.paymentCanasta.token_id = "\(id)"
                Constatns.LocalData.paymentCanasta.token_cliente = ""
                Constatns.LocalData.paymentCanasta.token_card = ""
                Constatns.LocalData.paymentCanasta.numeroTarjeta = "\( String(numeroTarjeta.suffix(4)))"
                
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is DetallePedidoViewController {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
            }
            else {
                self.addNewCard(token_id: "\(id)", id_user: UserManagement.shared.id_user!, completion: { (result) in
                    switch result {
                    case .failure(let errorMssg):
                      self.loader.removeAnimate()
                      self.throwError(str: errorMssg)
                    case .success(_):
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
           
            
            
            
            
            
            //self.navigationController?.popViewController(animated: true)
            
            
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
    func addNewCard(token_id :String , id_user: String,
                      completion: @escaping(Result) -> Void){
        
       
        var data2  : Parameters = [
            "funcion" : Routes.addCardV2,
            "token_id" : token_id,
            "id_user" : "\(id_user)"
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data2).responseData { (response) in
             print("add card response")
             print(data2)
             print(response.debugDescription)
            
             if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                 print("Data: \(utf8Text)")
                 let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                 
                 if let dictionary = json as? Dictionary<String, AnyObject> {
                     if let info = dictionary["data"] as? Dictionary<String, Any> {
                         print(info)
                         
                     }
                 }
                 
             }
             
             guard let data = response.result.value else {
                 completion(.failure("Error de conexión"))
                 return
             }
             
             guard let dictionary = JSON(data).dictionary else {
                 completion(.failure("Error al obtener los datos"))
                 return
             }
             
             if dictionary["state"] != "200" {
                 completion(.failure(dictionary["status_msg"]?.string ?? ""))
                 return
             }
             completion(.success([]))
         }
        
        
         
    }
    
}
