//
//  Deposits.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Deposit: Decodable {
  public var id: String?
  public var amount: String?
  public var digits: String?
  public var date: String?
  public var type: String?
  public var cardHolder: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case amount = "monto"
    case digits = "digits"
    case date = "fecha"
    case type = "type"
    case cardHolder = "titular"
  }
}

class Deposits: Decodable {
  public var deposits: [Deposit] = []
  
  enum CodingKeys: String, CodingKey {
    case deposits = "data"
  }
  
  func requestDeposits(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getPayments,
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
      
      guard let object = try? JSON(data).rawData(),
        let decoded = try? JSONDecoder().decode(Deposits.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.deposits = decoded.deposits
      completion(.success([]))
    }
  }
}

