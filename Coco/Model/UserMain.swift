//
//  UserMain.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class HomeSetupDataModel: Decodable {
    public var info: UserMain?
    public var ultimo_pedido: String?
    
    public init(info: UserMain? = nil,
                ultimo_pedido: String? = nil) {
        self.info = info
        self.ultimo_pedido = ultimo_pedido
    }
    
    enum CodingKeys: String, CodingKey {
        case info, ultimo_pedido
    }
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        info = try decoder.decode(UserMain.self, forKey: .info)
        
        ultimo_pedido = (try? decoder.decode(String.self, forKey: .ultimo_pedido)) ??
            (try? decoder.decode(Int.self, forKey: .ultimo_pedido).description)
    }
}

class UserMain: Decodable {
  public var name: String?
  public var last_name: String?
  public var email: String?
  public var phone: String?
  public var notifications: String?
  public var current_balance: String?
  public var cocopoints_balance: String?
  public var codigo_referido: String?
    
  public init(name: String = "",
              last_name: String = "",
              email: String = "",
              phone: String = "",
              notifications: String = "",
              current_balance: String = "",
              cocopoints_balance: String = "",
              codigo_referido: String = "") {
    self.name = name
    self.last_name = last_name
    self.email = email
    self.phone = phone
    self.notifications = notifications
    self.current_balance = current_balance
    self.cocopoints_balance = cocopoints_balance
    self.codigo_referido = codigo_referido
  }
  
  enum CodingKeys: String, CodingKey {
    case name = "nombre"
    case last_name = "apellidos"
    case email = "correo"
    case phone = "telefono"
    case notifications = "notificaciones"
    case current_balance = "saldo_actual"
    case cocopoints_balance = "saldo_cocopoints"
    case codigo_referido = "codigo_referido"
  }
}

class Main: Decodable {
  public var info: UserMain?
  public var stores: [Business]
  
  public init(info: UserMain? = nil,
              stores: [Business] = []) {
    self.info = info
    self.stores = stores
  }
  
  enum CodingKeys: String, CodingKey {
    case info = "info"
    case stores = "tiendas"
  }
  
  func requestUserMain(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getMainData,
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
      
      if dictionary["state"] != "200" {
        completion(.failure(dictionary["status_msg"]?.string ?? ""))
        return
      }
                        
                        if dictionary["state"] == "200" {
                            
                            print(dictionary)
                            
                        }
      
      guard let dataDictionary = dictionary["data"],
        let object = try? dataDictionary.rawData(),
        let decoded = try? JSONDecoder().decode(Main.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.info = decoded.info
      self.stores = decoded.stores
      completion(.success([]))
    }
  }
}
