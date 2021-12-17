//
//  Schools.swift
//  Coco
//
//  Created by Carlos Banos on 7/8/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class School: Decodable {
  public var id: String?
  public var name: String?
  
  public init(id: String = "",
              name: String = "") {
    self.id = id
    self.name = name
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case name = "nombre"
  }
}

class Schools: Decodable {
  public var schools = [School]()
  
  public init(schools: [School] = []) {
    self.schools = schools
  }
  
  enum CodingKeys: String, CodingKey {
    case schools = "data"
  }
  
  func getSchoolsRequest(completion: @escaping(Result) -> Void) {
    let data = [
      "funcion": Routes.getSchools]
    
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
        let decoded = try? JSONDecoder().decode(Schools.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.schools = decoded.schools
      completion(.success(nil))
    }
  }
}
