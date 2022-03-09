//
//  OrdersFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class OrdersFetcher {
    static func fetchOrders(completion: @escaping (Swift.Result<[Order],Error>) -> Void) {
        let data = [
            "funcion": Routes.getOrders,
            "id_user": UserManagement.shared.id_user!
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            print(response.debugDescription)
            guard let data = response.result.value else {
                print("opcion1")
                completion(.failure(FetcherErrors.invalidResponse))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                print("opcion2")
                completion(.failure(FetcherErrors.jsonMapping))
                return
            }
            
            guard dictionary["state"] == "200" else {
                let error = dictionary["status_msg"]?.string
                print("opcion3")
                completion(.failure(FetcherErrors.statusCode(error)))
                return
            }
            print("Diccionario")
            print(dictionary)
            guard let dataDictionary = dictionary["data"],
              let object = try? dataDictionary.rawData(),
              let decoded = try? JSONDecoder().decode([Order].self, from: object) else {
                print("opcion4")
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func fetchOrderDetail(orderId: String, completion: @escaping (Swift.Result<OrdersDetail,Error>) -> Void) {
        let data = [
            "funcion": Routes.getOrdersDetail,
            "id_user": UserManagement.shared.id_user!,
            "id_order": orderId
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
              let decoded = try? JSONDecoder().decode(OrdersDetail.self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func yaLlegue(id_order: String, completion: @escaping (Swift.Result<Void,Error>) -> Void) {
        let data = [
            "funcion": Routes.ya_llegue,
            "id_order": id_order
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
