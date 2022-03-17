//
//  CategoriesFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class CategoriesFetcher {
    static func fetchCategories(locationId: String, completion: @escaping (Swift.Result<[Category],Error>) -> Void) {
        
        let id = UserManagement.shared.id_user ?? ""
        let data = [
            "funcion": Routes.getCategories,
            "id_user": id == "" ? "525" : id,
            "id_provider": locationId,
            "latitude": "0.0",
            "longitude": "0.0"
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            print(data)
            guard let data = response.result.value else {
                completion(.failure(FetcherErrors.invalidResponse))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure(FetcherErrors.jsonMapping))
                return
            }
            
            guard dictionary["state"] == "200" else {
                let error = dictionary["status_msg"]?.string
                completion(.failure(FetcherErrors.statusCode(error)))
                return
            }
            
            guard let dataDictionary = dictionary["data"],
              let object = try? dataDictionary.rawData(),
              let decoded = try? JSONDecoder().decode([Category].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
}

