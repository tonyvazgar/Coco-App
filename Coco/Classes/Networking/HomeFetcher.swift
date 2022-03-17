//
//  HomeFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 10/8/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class HomeFetcher {
    static func fetchMain(completion: @escaping (Swift.Result<HomeSetupDataModel,Error>) -> Void) {
        
        let id = UserManagement.shared.id_user ?? ""
        
        
        let data = [
            "funcion": Routes.getMainData,
            "id_user": id == "" ? "525" : id
        ]
        
    
        print("request: \(data)")
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            print(response.debugDescription)
            print("1")
            guard let data = response.result.value else {
                completion(.failure(FetcherErrors.invalidResponse))
                return
            }
            print("2")
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure(FetcherErrors.jsonMapping))
                return
            }
            print("3")
            guard dictionary["state"] == "200" else {
                let error = dictionary["status_msg"]?.string
                completion(.failure(FetcherErrors.statusCode(error)))
                return
            }
            print("4")
            guard let dataDictionary = dictionary["data"],
              let object = try? dataDictionary.rawData(),
              let decoded = try? JSONDecoder().decode(HomeSetupDataModel.self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            print("5")
            completion(.success(decoded))
        }
    }
}
