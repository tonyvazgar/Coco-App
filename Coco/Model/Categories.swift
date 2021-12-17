//
//  Categories.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Category: Decodable {
  public var id: String?
  public var name: String?
  public var imageURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case name = "nombre"
    case imageURL = "imagen"
  }
}

class Categories: Decodable {
  public var categories: [Category] = []
  
  enum CodingKeys: String, CodingKey {
    case categories = "data"
  }
  
  func requestCategories(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getCategories,
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
        let decoded = try? JSONDecoder().decode(Categories.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.categories = decoded.categories
      completion(.success([]))
    }
  }
}

