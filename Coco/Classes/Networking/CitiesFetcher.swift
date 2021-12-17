//
//  CitiesFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 11/10/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class CitiesFetcher {
    static func fetchCities(completion: @escaping (Swift.Result<[CityDataModel],Error>) -> Void) {
        let data = [
            "funcion": Routes.getCities
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
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
              let decoded = try? JSONDecoder().decode([CityDataModel].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func updateCity(id_city: String, completion: @escaping (Swift.Result<Void,Error>) -> Void) {
        let data = [
            "funcion": Routes.updateCity,
            "id_user": UserManagement.shared.id_user!,
            "id_city": id_city
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
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
            
            completion(.success(()))
        }
    }
}
