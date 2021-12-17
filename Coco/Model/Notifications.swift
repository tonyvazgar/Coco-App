//
//  Notifications.swift
//  Coco
//
//  Created by Carlos Banos on 8/13/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Notifications: Decodable {
  
  func updateRequest(completion: @escaping(Result) -> Void) {
    let data = [
      "funcion": Routes.sendToken,
      "id_user": UserManagement.shared.id_user ?? "",
      "type_device": "1",
      "token": UserManagement.shared.token ?? ""]
    
    Alamofire.request(General.url_connection,
                      method: .post,
                      parameters: data).responseJSON { (response) in
      guard let data = response.result.value else {
        completion(.failure(response.error.debugDescription))
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
      completion(.success(dictionary["data"]!))
    }
  }
}
