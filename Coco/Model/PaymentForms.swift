//
//  PaymentForms.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PaymentForm: Decodable {
  public var id: String?
  public var digits: String?
  public var type: String?
  public var methodCustomer: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case digits = "digits"
    case type = "type"
    case methodCustomer = "method_customer"
  }
  
  func removePaymentForm(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.quitTokensUser,
      "id_user": UserManagement.shared.id_user,
      "id_token": id ?? ""
    ]
    
    Alamofire.request(General.endpoint,
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
      completion(.success([]))
    }
  }
}

class PaymentForms: Decodable {
  public var paymentForm: [PaymentForm] = []
  
  enum CodingKeys: String, CodingKey {
    case paymentForm = "data"
  }
  
  func requestPaymentForms(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getTokens,
      "id_user": UserManagement.shared.id_user
    ]
    
    Alamofire.request(General.url_connection,
                      method: .post,
                      parameters: data).responseJSON { (response) in
                        print(response)
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
        let decoded = try? JSONDecoder().decode(PaymentForms.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.paymentForm = decoded.paymentForm
      completion(.success([]))
    }
  }
}

