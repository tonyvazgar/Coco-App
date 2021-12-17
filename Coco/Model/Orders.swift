//
//  Orders.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Order: Decodable {
  public var id: String?
  public var amount: String?
  public var tip: String?
  public var business: String?
  public var total: String?
  public var imageURL: String?
  public var date: String?
  public var status: String?
  public var comments: String?
  public var tipPercentage: String?
  public var cocopoints: Int?
  public var tipoDeCompra: String?
  public var totalCocopoints: String?
  public var tiempoEstimado: Int?
  public var cocopointsOtorgados: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case amount = "monto"
    case tip = "propina"
    case business = "nombre"
    case total = "total"
    case imageURL = "imagen"
    case date = "fecha"
    case status = "estatus"
    case comments = "comentarios"
    case tipPercentage = "procentaje_propina"
    case cocopoints = "cocopoints"
    case tipoDeCompra = "tipo_compra"
    case totalCocopoints = "monto_cocopoints"
    case tiempoEstimado = "tiempo_estimado"
    case cocopointsOtorgados = "cocopoints_otorgados"
    
  }
}

class Orders: Decodable {
  public var orders: [Order] = []
  
  enum CodingKeys: String, CodingKey {
    case orders = "data"
  }
  
  func requestOrders(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getOrders,
      "id_user": UserManagement.shared.id_user!
    ]
    
    Alamofire.request(General.url_connection,
                      method: .post,
                      parameters: data).responseJSON { (response) in
      guard let data = response.result.value else {
        completion(.failure("Error de conexión"))
        return
      }
      
      guard let dictionary = JSON(data).dictionary else {
        completion(.failure("Error al obtener los datos"))
        return
      }
                        
      let orderEstimatedTime = try? JSONDecoder().decode(OrderEstimatedTime.self, from: response.data!)                        
                        
      if dictionary["state"] != "200" {
        completion(.failure(dictionary["status_msg"]?.string ?? ""))
        return
      }
      
      guard let object = try? JSON(data).rawData(),
        let decoded = try? JSONDecoder().decode(Orders.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.orders = decoded.orders
      completion(.success([]))
    }
  }
}

class OrdersDetail: Decodable {
  public var order: Order!
  public var products: [Product] = []
  
  public init(order: Order) {
    self.order = order
  }
  
  enum CodingKeys: String, CodingKey {
    case order = "info"
    case products = "products"
  }
  
  func requestOrders(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getOrdersDetail,
      "id_user": UserManagement.shared.id_user!,
      "id_order": order.id ?? "0"
    ]
    
    Alamofire.request(General.url_connection,
                      method: .post,
                      parameters: data).responseJSON { (response) in
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                          print("Data: \(utf8Text)")
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
      
      guard let dataDictionary = dictionary["data"],
        let object = try? dataDictionary.rawData(),
        let decoded = try? JSONDecoder().decode(OrdersDetail.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.order = decoded.order
      self.products = decoded.products
      completion(.success([]))
    }
  }
}
