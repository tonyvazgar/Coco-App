//
//  DetallePedidoViewController.swift
//  Coco
//
//  Created by Erick Monfil on 28/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class DetallePedidoViewController: UIViewController {
    private var loader: LoaderVC!
    private var shoppingCart: ShoppingCart?
    @IBOutlet weak var vistaRestaurante: UIView!
    @IBOutlet weak var vistaImagenRestaurante: UIView!
    @IBOutlet weak var imgRestaurante: UIImageView!
    
    
    @IBOutlet weak var vistaMetodoPago: UIView!
    @IBOutlet weak var vistaImagenMetodoDePago: UIView!
    @IBOutlet weak var btnPagar: UIButton!
    
    @IBOutlet weak var vistaOtrosMetodosPago: UIView!
    @IBOutlet weak var vistaCocoPoints: UIView!
    @IBOutlet weak var vistaCupones: UIView!
    @IBOutlet weak var vistaValorCupon: UIView!
    
    @IBOutlet weak var vistaMetodoPickup: UIView!
    @IBOutlet weak var vistaIconoPickup: UIView!
    
    @IBOutlet weak var vistaPropina1: UIView!
    @IBOutlet weak var vistaPropina2: UIView!
    @IBOutlet weak var vistaPropina3: UIView!
    
    @IBOutlet weak var vistaComentario: UIView!
    
    
    @IBOutlet weak var lblNombreLocation: UILabel!
    @IBOutlet weak var lblHorarioLocation: UILabel!
    @IBOutlet weak var lblDireccionLocation: UILabel!
    
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblPropina: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var txtComentarios: UITextView!
    
    var categoryId: String?
    var location: LocationsDataModel?
    var arrCanasta : [pedidoObject] = [pedidoObject]()
    var subTotal : Double = 0
    
    var tipoPago : Int = 3 //3=saldo
    var pickUp : Int = 1
    var porcentagePropina : Int = 5
    var propina : Double = 0
    var total : Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        
        
        lblNombreLocation.text = location?.name ?? ""
        lblHorarioLocation.text = location?.schedule ?? ""
        lblDireccionLocation.text = location?.address ?? ""
        
        if let image = location?.imgURL {
            imgRestaurante.kf.setImage(with: URL(string: image),
                                      placeholder: nil,
                                      options: [.transition(.fade(0.4))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        }
        
        vistaRestaurante.layer.cornerRadius = 30
        vistaRestaurante.backgroundColor = .white
        vistaRestaurante.layer.shadowColor = gris.cgColor
        vistaRestaurante.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaRestaurante.layer.shadowOpacity = 0.7
        vistaRestaurante.layer.shadowRadius = 15
        
        vistaImagenRestaurante.layer.cornerRadius = 94/2
        vistaImagenRestaurante.layer.shadowColor = UIColor.gray.cgColor
        vistaImagenRestaurante.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaImagenRestaurante.layer.shadowOpacity = 0.5
        vistaImagenRestaurante.layer.shadowRadius = 3
        imgRestaurante.layer.cornerRadius = 94/2
        imgRestaurante.clipsToBounds = true
        
        vistaMetodoPago.layer.cornerRadius = 30
        vistaMetodoPago.backgroundColor = .white
        vistaMetodoPago.layer.shadowColor = gris.cgColor
        vistaMetodoPago.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaMetodoPago.layer.shadowOpacity = 0.7
        vistaMetodoPago.layer.shadowRadius = 15
        
        vistaImagenMetodoDePago.layer.cornerRadius = 94/2
        vistaImagenMetodoDePago.layer.shadowColor = UIColor.gray.cgColor
        vistaImagenMetodoDePago.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaImagenMetodoDePago.layer.shadowOpacity = 0.5
        vistaImagenMetodoDePago.layer.shadowRadius = 3
        
        btnPagar.layer.cornerRadius = 20
        
        vistaOtrosMetodosPago.layer.cornerRadius = 30
        vistaOtrosMetodosPago.backgroundColor = .white
        vistaOtrosMetodosPago.layer.shadowColor = gris.cgColor
        vistaOtrosMetodosPago.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaOtrosMetodosPago.layer.shadowOpacity = 0.7
        vistaOtrosMetodosPago.layer.shadowRadius = 15
        
        vistaCocoPoints.layer.cornerRadius = 94/2
        vistaCocoPoints.layer.shadowColor = UIColor.gray.cgColor
        vistaCocoPoints.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaCocoPoints.layer.shadowOpacity = 0.5
        vistaCocoPoints.layer.shadowRadius = 3
        
        vistaCupones.layer.cornerRadius = 94/2
        vistaCupones.layer.shadowColor = UIColor.gray.cgColor
        vistaCupones.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaCupones.layer.shadowOpacity = 0.5
        vistaCupones.layer.shadowRadius = 3
        
        vistaValorCupon.layer.cornerRadius = 10
        vistaValorCupon.layer.shadowColor = UIColor.gray.cgColor
        vistaValorCupon.layer.shadowOffset = CGSize(width: 0, height: 0)
        vistaValorCupon.layer.shadowOpacity = 0.5
        vistaValorCupon.layer.shadowRadius = 3
        
        vistaMetodoPickup.layer.cornerRadius = 30
        vistaMetodoPickup.backgroundColor = .white
        vistaMetodoPickup.layer.shadowColor = gris.cgColor
        vistaMetodoPickup.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaMetodoPickup.layer.shadowOpacity = 0.7
        vistaMetodoPickup.layer.shadowRadius = 15
        
        vistaIconoPickup.layer.cornerRadius = 94/2
        vistaIconoPickup.layer.shadowColor = UIColor.gray.cgColor
        vistaIconoPickup.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaIconoPickup.layer.shadowOpacity = 0.5
        vistaIconoPickup.layer.shadowRadius = 3
        
        vistaPropina1.layer.cornerRadius = 93/2
        vistaPropina1.layer.shadowColor = gris.cgColor
        vistaPropina1.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaPropina1.layer.shadowOpacity = 0.7
        vistaPropina1.layer.shadowRadius = 15
        
        vistaPropina2.layer.cornerRadius = 93/2
        vistaPropina2.layer.shadowColor = gris.cgColor
        vistaPropina2.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaPropina2.layer.shadowOpacity = 0.7
        vistaPropina2.layer.shadowRadius = 15
        
        vistaPropina3.layer.cornerRadius = 93/2
        vistaPropina3.layer.shadowColor = gris.cgColor
        vistaPropina3.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaPropina3.layer.shadowOpacity = 0.7
        vistaPropina3.layer.shadowRadius = 15
        
        vistaComentario.layer.cornerRadius = 20
        vistaComentario.layer.shadowColor = gris.cgColor
        vistaComentario.layer.shadowOffset = CGSize(width: 0, height: 30)
        vistaComentario.layer.shadowOpacity = 0.7
        vistaComentario.layer.shadowRadius = 30
        
        lblSubTotal.text = "$\(self.subTotal)"
        propina = (Double(self.porcentagePropina) * self.subTotal) / 100
        lblPropina.text = "$\(propina)"
        lblTotal.text = "$\(propina + subTotal)"
        self.total = propina + subTotal
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectPickupAction(_ sender: UIButton) {
        
        let viewController = UIStoryboard.pickups.instantiate(PickUpListViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func selectPaymentMethodAction(_ sender: UIButton){
        let viewController = UIStoryboard.payments.instantiate(ListaTarjetasViewController.self)
    
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func hacerPedidoAction(_ sender: UIButton) {
        
        
        
        var arrProductosCanasta : [ProductoCanasta] = [ProductoCanasta]()
        for item in arrCanasta {
            
            var arrIngredientes : [IngredienteCanasta] = [IngredienteCanasta]()
            var arrextras : [ExtraCanasta] = [ExtraCanasta]()
            var arrOpcion1 : [options_1Canasta] = [options_1Canasta]()
            var arrOpcion2 : [options_1Canasta] = [options_1Canasta]()
            for a in item.Configuracion {
                switch a.tipo {
                case "ingrediente":
                    for b in a.valores {
                        let ingrediente : IngredienteCanasta = IngredienteCanasta(id_ingredient: b.id)
                        arrIngredientes.append(ingrediente)
                    }
                    break
                case  "extras":
                    for b in a.valores {
                        if b.cantidad > 0 {
                            let extra : ExtraCanasta = ExtraCanasta(id_extra: b.id, id_product: item.producto.id!, price: b.precio, qty:"\(b.cantidad)")
                            arrextras.append(extra)
                        }
                        
                    }
                    break
                case "opcion1":
                    for b in a.valores {
                        if b.seleccionado == true {
                            let options_1: options_1Canasta = options_1Canasta(id_options: b.id, id_product: item.producto.id!, price: b.precio)
                            arrOpcion1.append(options_1)
                        }
                    }
                    break
                case "opcion2":
                    for b in a.valores {
                        if b.seleccionado == true {
                            let options_2: options_1Canasta = options_1Canasta(id_options: b.id, id_product: item.producto.id!, price: b.precio)
                            arrOpcion2.append(options_2)
                        }
                        
                    }
                default:
                    
                    break
                }
                if a.tipo == "ingredientes" {
                    
                }
            }
            
            var productoCanasta : ProductoCanasta = ProductoCanasta(id: item.producto.id!, cantidad: "\(item.cantidad)", precio: item.producto.price!, ingredients: arrIngredientes, extras: arrextras, options_1: arrOpcion1, options_2: arrOpcion2)
            arrProductosCanasta.append(productoCanasta)
        }
        
        var arrNewCard : [new_cardCanasta] = [new_cardCanasta]()
        let card : new_cardCanasta = new_cardCanasta(nombre: "", card_number: "", date_expiration: "", cvv: "")
        arrNewCard.append(card)
        
        let paimnetC : paymentCanasta = paymentCanasta(forma_pago: "\(self.tipoPago)", token_cliente: UserManagement.shared.token!, token_card: "", new_card: arrNewCard)
        let pickCa  : pickupCanasta = pickupCanasta(id: "\(self.pickUp)", marca: "", color: "", placas: "")
        
        let request : OrdenRequest = OrdenRequest(funcion: Routes.saveOrder, id_user: UserManagement.shared.id_user!, sub_amount: "\(self.subTotal)", percentage_service: "\(self.porcentagePropina)", amount_service: "\(self.propina)", amount_final: "\(self.total)", id_store: self.location!.id!, products: arrProductosCanasta, comments: txtComentarios.text!, pickup: pickCa, payment: paimnetC)
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(request)
            
            print("Data : \(data)")
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()

                    // Decode Note
                    let reqJson = try decoder.decode(OrdenRequest.self, from: data)
                    print("Request:\(reqJson)")
                    
                    
                    
                    
                    let encoder = JSONEncoder()
                    let insectData: Data? = try? encoder.encode(request.products)
                    let insectDataPickUps: Data? = try? encoder.encode(request.pickup)
                    let insectDataPayment: Data? = try? encoder.encode(request.payment)
                    
                    
                    var productosString : String = ""
                    var pickUpString : String = ""
                    var paymentString : String = ""
                    
                    if let insectData = try? encoder.encode(request.products),
                        let jsonString = String(data: insectData, encoding: String.Encoding.ascii)
                        {
                        print("Nuevo json")
                        print(jsonString.description)
                        productosString = jsonString.description
                    }
                    if let insectDataPickUps = try? encoder.encode(request.pickup),
                        let jsonString = String(data: insectDataPickUps, encoding: String.Encoding.ascii)
                        {
                        print("Nuevo json")
                        print(jsonString.description)
                        pickUpString = jsonString.description
                    }
                    if let insectDataPayment = try? encoder.encode(request.payment),
                        let jsonString = String(data: insectDataPayment, encoding: String.Encoding.ascii)
                        {
                        print("Nuevo json")
                        print(jsonString.description)
                        paymentString = jsonString.description
                    }
                    
                    
                    
                    /*
                    print("request2")
                    guard let dict = try? request.asDictionary() else {
                        return
                    }
                    print(dict)
 */
                    let dictionary: [String : Any] = try wrap(request)
                    print("Request2")
                    print(dictionary)
                    
                    
                   
                    
                    showLoader(&loader, view: view)
                    
                    
                    guard let dict = try? request.asDictionary() else {
                        return
                    }
                    print("dicccionary")
                    print(dict)
                    var jsonTextProductos = ""
                    var jsonTextPayments = ""
                    var jsonTextPickUps = ""
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: dictionary["products"] as Any,
                        options: .prettyPrinted
                        ),
                        let theJSONText = String(data: theJSONData,
                                                 encoding: String.Encoding.ascii) {
                        jsonTextProductos = theJSONText
                    }
                    
                    if let theJSONDataP = try? JSONSerialization.data(
                        withJSONObject: dictionary["payment"] as Any,
                        options: .prettyPrinted
                        ),
                        let theJSONText = String(data: theJSONDataP,
                                                 encoding: String.Encoding.ascii) {
                        jsonTextPayments = theJSONText
                    }
                    
                    if let theJSONDataPiu = try? JSONSerialization.data(
                        withJSONObject: dictionary["pickup"] as Any,
                        options: .prettyPrinted
                        ),
                        let theJSONText = String(data: theJSONDataPiu,
                                                 encoding: String.Encoding.ascii) {
                        jsonTextPickUps = theJSONText
                    }
                    
                    saveOrderNew(obj: request, request: dictionary, parameters: dict,productos: productosString,percentage_service: request.percentage_service,id_store: request.id_store,payment: paymentString,
                                 sub_amount: request.sub_amount,
                                 comments: request.comments,
                                 amount_service: request.amount_service,
                                 amount_final: request.amount_final,
                                 id_user: request.id_user,
                                 pickup: pickUpString,
                                 completion: { result in
                        self.loader.removeAnimate()
                        switch result {
                        case .failure(let errorMssg):
                            self.throwError(str: errorMssg)
                            return
                        case .success(_):
                            
                            // Register Nib
                            let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                            newViewController.modalPresentationStyle = .fullScreen

                            // Present View "Modally"
                            self.present(newViewController, animated: true, completion: nil)
                        }
                    })
                    
                    
                    
                } catch {
                    print("Unable to Decode request (\(error))")
                }
            
            
            

        } catch {
            print("Unable to Encode request (\(error))")
        }
        
        
        /*
        let viewController = UIStoryboard.shoppingCart.instantiate(FinPedidoViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
 */
    }
    
    func calcularTotalPedido(pedido : pedidoObject) -> Double{
        var tS = pedido.producto.price ?? "0"
        var total : Double = Double(tS)!
        
        for item in pedido.Configuracion {
            for producto in item.valores {
                if producto.tipo == "extras" {
                    total = total + (Double(producto.cantidad) * (Double(producto.precio) ?? 0))
                }
                else {
                    if producto.seleccionado == true {
                        total = total + Double(producto.precio)!
                    }
                }
            }
        }
        total = total * Double(pedido.cantidad)
        return total
    }
    
    func calcularSubtotal() -> Double {
        var total : Double = 0
        for item in self.arrCanasta {
           total = total + calcularTotalPedido(pedido: item)
        }
        return total
    }
    
    func saveOrderNew(obj :OrdenRequest ,request : [String : Any],parameters: [String: Any],
                      productos : String,
                      percentage_service : String,
                      id_store : String,
                      payment : String,
                      sub_amount : String,
                      comments : String,
                      amount_service : String,
                      amount_final : String,
                      id_user : String,
                      pickup : String,
                      completion: @escaping(Result) -> Void){
        
        var data = parameters
        data["products"] = productos
        data["funcion"] = Routes.saveOrder
        data["id_user"] = UserManagement.shared.id_user!
        data["percentage_service"] = percentage_service
        data["id_store"] = id_store
        data["payment"] = payment
        data["sub_amount"] = sub_amount
        data["comments"] = comments
        data["amount_service"] = amount_service
        data["amount_final"] = amount_final
        data["pickup"] = pickup
        
        let p = productos.data(using:.utf8)!.prettyPrintedJSONString
        let ups = pickup.data(using:.utf8)!.prettyPrintedJSONString
        let pay = payment.data(using:.utf8)!.prettyPrintedJSONString
        
        
        var produa : String = ""
        var data2  : Parameters = [
            "funcion" : Routes.saveOrder,
            "id_user" : UserManagement.shared.id_user ?? "",
            "sub_amount" : "\(sub_amount)",
            "percentage_service" : "\(percentage_service)",
            "amount_service" : "\(amount_service)",
            "amount_final" : "\(amount_final)",
            "id_store" : "\(id_store)",
            "products" : productos,
            "comments" : comments,
            "pickup" : pickup,
            "payment" : payment
        ]
        
        let headers:HTTPHeaders=[
                "Content-Type":"multipart/form-data"]
        
        
       
        Alamofire.request(General.endpoint, method: .post, parameters: data2).responseString { (response) in
             print("Product bought wih money")
             print(data2)
             print(response.debugDescription)
            
             
             /*
             if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                 print("Data: \(utf8Text)")
                 let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                 
                 if let dictionary = json as? Dictionary<String, AnyObject> {
                     if let info = dictionary["data"] as? Dictionary<String, Any> {
                         print(info)
                         let tiempoEstimado = info["TiempoEstimado"]
                         let cocosOtorgados = info["Cocopoints"]
                         UserDefaults.standard.set(tiempoEstimado, forKey: "estimatedValue")
                         UserDefaults.standard.set(cocosOtorgados, forKey: "cocosOtorgados")
                     }
                 }
                 
                 UserDefaults.standard.set(true, forKey: "gotCocos")
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
             completion(.success([]))*/
         }
        
        
         
    }
}


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
