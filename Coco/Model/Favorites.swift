//
//  Favorites.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Favorites: Decodable {
  public var favorites: [FavoriteProduct] = []
  
  enum CodingKeys: String, CodingKey {
    case favorites = "data"
  }
  
  func requestFavorites(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getFavorites,
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
        let decoded = try? JSONDecoder().decode(Favorites.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.favorites = decoded.favorites
      completion(.success([]))
    }
  }
}

class FavoriteProduct: Decodable {
  public var id: String?
  public var name: String?
  public var imageURL: String?
  public var schedule: String?
  public var business: String?
  public var id_product: String?
  
  public init(id: String = "",
              name: String = "",
              imageURL: String = "",
              schedule: String = "",
              business: String = "",
              id_product: String = "") {
    self.id = id
    self.name = name
    self.imageURL = imageURL
    self.schedule = schedule
    self.business = business
    self.id_product = id_product
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case name = "nombre"
    case imageURL = "imagen"
    case business = "proveedor"
    case schedule = "horario"
    case id_product = "id_producto"
  }
  
  func requestStatusFavorite(status: String, completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.adminFavorite,
      "id_user": UserManagement.shared.id_user!,
      "id_product": id_product ?? "",
      "active": status
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
      
      completion(.success([]))
    }
  }
}
