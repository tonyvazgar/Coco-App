//
//  Cards.swift
//  Coco
//
//  Created by Carlos Banos on 7/8/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Cards: Decodable {
  public var id: String
  public var name: String?
  public var address: String?
  public var second_address: String?
  public var zip: String?
  public var number: String?
  public var digits: String?
  public var type: String?
  public var token: String?
  public var auto: String?
  public var amount: String?
  
  public init(id: String = "",
              name: String = "",
              address: String = "",
              second_address: String = "",
              zip: String = "",
              number: String = "",
              digits: String = "",
              type: String = "",
              token: String = "",
              auto: String = "",
              amount: String = "") {
    self.id = id
    self.name = name
    self.address = address
    self.second_address = second_address
    self.zip = zip
    self.number = number
    self.digits = digits
    self.type = type
    self.token = token
    self.auto = auto
    self.amount = amount
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case digits
    case type
    case token = "method_customer"
  }
  
  func addCard(completion: @escaping(Result) -> Void){
    let data: [String: String] = [
      "funcion": Routes.addCard,
      "id_user": UserManagement.shared.id_user!,
      "name": self.name ?? "",
      "address": self.address ?? "",
      "colony": self.second_address ?? "",
      "zip": self.zip ?? "",
      "number": self.number ?? "",
      "digits": self.digits ?? "",
      "type": self.type ?? "",
      "token": self.token ?? "",
      "auto": self.auto ?? "0",
      "amount": self.amount ?? "0"
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

class MyCards: Decodable {
  public var cards: [Cards]
  
  public init(cards: [Cards] = []) {
    self.cards = cards
  }
  
  enum CodingKeys: String, CodingKey {
    case cards = "data"
  }
  
  func requestCards(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getTokens,
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
        let decoded = try? JSONDecoder().decode(MyCards.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.cards = decoded.cards
      completion(.success([]))
    }
  }
}

