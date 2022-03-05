//
//  ShoppingCart.swift
//  Coco
//
//  Created by Carlos Banos on 7/17/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ShoppingCart: Codable {
    
    public var sub_amount: String?
    public var percentage_service: String?
    public var amount_service: String?
    public var amount_final: String?
    public var id_store: String?
    public var location: LocationsDataModel?
    public var store_name: String?
    public var comments: String?
    public var products: [Product] = []
    public var cocopoints: Int?
    
    public init(sub_amount: String? = "",
                percentage_service: String? = "",
                amount_service: String? = "",
                amount_final: String? = "",
                id_store: String? = "",
                store_name: String? = "",
                comments: String? = "",
                cocopoints: Int? = 0,
                location: LocationsDataModel? = nil) {
        self.sub_amount = sub_amount
        self.percentage_service = percentage_service
        self.amount_service = amount_service
        self.amount_final = amount_final
        self.id_store = id_store
        self.store_name = store_name
        self.comments = comments
        self.cocopoints = cocopoints
        self.location = location
    }
    
    enum CodingKeys: String, CodingKey {
        case sub_amount
        case percentage_service
        case amount_service
        case amount_final
        case id_store
        case comments
        case products
        case store_name
        case cocopoints
        case location
    }
    
    func addProduct(product: Product, location: LocationsDataModel? = nil) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].quantity = product.quantity
            var totalAccount: Float = 0.0
            for item in products {
                let price = NumberFormatter().number(from: item.price!) ?? 0.0
                let quantity = NumberFormatter().number(from: item.quantity!) ?? 0.0
                totalAccount += (price.floatValue * quantity.floatValue)
            }
            sub_amount = "\(totalAccount)"
        } else {
            products.append(product)
            var totalAccount: Float = 0.0
            for item in products {
                let price = NumberFormatter().number(from: item.price!) ?? 0.0
                let quantity = NumberFormatter().number(from: item.quantity!) ?? 0.0
                totalAccount += (price.floatValue * quantity.floatValue)
            }
            sub_amount = "\(totalAccount)"
        }
        if location != nil { self.location = location }
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func saveOrder(products: String, parameters: [String: Any], completion: @escaping(Result) -> Void){
        var data = parameters
        data["products"] = products
        data["funcion"] = Routes.saveOrder
        data["id_user"] = UserManagement.shared.id_user!
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            print("Product bought wih money")
            print(data)
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
            completion(.success([]))
        }
    }
    
    func saveOrderNew(parameters: [String: Any], completion: @escaping(Result) -> Void){
       
        Alamofire.request(General.endpoint, method: .post, parameters: parameters).responseJSON { (response) in
            print("Product bought wih money")
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
            completion(.success([]))
        }
    }
    
    func saveOrder2(products: String, parameters: [String: Any], completion: @escaping(Result) -> Void){
        var data = parameters
        data["products"] = products
        data["funcion"] = Routes.saveOrderCocopoints
        data["id_user"] = UserManagement.shared.id_user!
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            
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
                        UserDefaults.standard.set(false, forKey: "gotCocos")
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
    
    func saveOrderGiftMoney(idFriend: String, friendMessage: String, products: String, parameters: [String: Any], completion: @escaping(Result) -> Void){
        var data = parameters
        data["products"] = products
        data["funcion"] = "saveOrderPresent"
        data["id_user"] = UserManagement.shared.id_user!
        data["order_type"] = "2"
        data["id_user_present"] = idFriend
        data["friend_message"] = friendMessage
        
        print("This is the JSON")
        print(data)
        
        Alamofire.request(General.url_connection, method: .post, parameters: data).responseJSON { (response) in
            
            print("product bought with cocopoints and its a gift")
            print(data)
            
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
                        UserDefaults.standard.set(true, forKey: "gotCocos")
                    }
                }
            }
            
            guard let data = response.result.value else {
                print("We are here.")
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
    
    func saveOrderCocopointsGift(idFriend: String, friendMessage: String, products: String, parameters: [String: Any], completion: @escaping(Result) -> Void){
        var data = parameters
        data["products"] = products
        data["funcion"] = "saveOrderCocopointsPresent"
        data["id_user"] = UserManagement.shared.id_user!
        data["order_type"] = "2"
        data["id_user_present"] = idFriend
        data["friend_message"] = friendMessage
        
        Alamofire.request(General.url_connection, method: .post, parameters: data).responseJSON { (response) in
            
            print("THIS IS THE LAST DATA")
            print(data)
            print("*********************")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject> {
                    if let info = dictionary["data"] as? Dictionary<String, Any> {
                        print(info)
                        let tiempoEstimado = info["TiempoEstimado"]
                        print(tiempoEstimado)
                        let cocosOtorgados = info["Cocopoints"]
                        print(cocosOtorgados)
                        UserDefaults.standard.set(tiempoEstimado, forKey: "estimatedValue")
                        UserDefaults.standard.set(cocosOtorgados, forKey: "cocosOtorgados")
                        UserDefaults.standard.set(false, forKey: "gotCocos")
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
    
    func setService(percentage: Int) {
        guard let sub_amount = sub_amount,
              let subtotal = NumberFormatter().number(from: sub_amount)?.doubleValue else {
            return
        }
        percentage_service = "\(percentage)"
        let tipPercentage = Double(percentage)/100
        let tipAmount = subtotal * tipPercentage
        amount_service = "\(tipAmount)"
        amount_final = String(format: "%.2f", tipAmount + subtotal)
    }
}

class ShoppingCart2: Codable {
    
    public var amount_final: String?
    public var id_store: String?
    public var comments: String?
    public var products: [Product] = []
    public var cocopointsAmount: String?
    
    public init(sub_amount: String? = "",
                amount_final: String? = "",
                id_store: String? = "",
                comments: String? = "",
                cocopointsAmount: String? = "") {
        self.amount_final = amount_final
        self.id_store = id_store
        self.comments = comments
        self.cocopointsAmount = cocopointsAmount
    }
    
    enum CodingKeys: String, CodingKey {
        case amount_final
        case id_store
        case comments
        case products
        case cocopointsAmount
    }
    
    func addProduct(product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].quantity = product.quantity
            var totalAccount: Float = 0.0
            for item in products {
                let price = NumberFormatter().number(from: item.price!) ?? 0.0
                let quantity = NumberFormatter().number(from: item.quantity!) ?? 0.0
                totalAccount += (price.floatValue * quantity.floatValue)
            }
        } else {
            products.append(product)
            var totalAccount: Float = 0.0
            for item in products {
                let price = NumberFormatter().number(from: item.price!) ?? 0.0
                let quantity = NumberFormatter().number(from: item.quantity!) ?? 0.0
                totalAccount += (price.floatValue * quantity.floatValue)
            }
        }
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
}
