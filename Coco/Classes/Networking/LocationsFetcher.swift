//
//  LocationsFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class LocationsFetcher {
    static func fetchLocations(businessId: String, completion: @escaping (Swift.Result<[LocationsDataModel],Error>) -> Void) {
        let data = [
            "funcion": Routes.getLocationsList,
            "id_user": UserManagement.shared.id_user!,
            "id_establishment": businessId,
            "latitude": LocationManager.shared.latitude,
            "longitude": LocationManager.shared.longitude
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
              let decoded = try? JSONDecoder().decode([LocationsDataModel].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
}

