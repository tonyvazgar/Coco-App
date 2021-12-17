//
//  ProductsFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 10/10/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class ProductsFetcher {
    static func fetchProducts(locationId: String, categoryId: String, completion: @escaping (Swift.Result<[Product],Error>) -> Void) {
        let data = [
            "funcion": Routes.getProducts,
            "id_user": UserManagement.shared.id_user!,
            "id_store": locationId,
            "id_category": categoryId
        ]
        
        print(data)
        
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
                  let decoded = try? JSONDecoder().decode([Product].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func fetchProductDetail(productId: String, completion: @escaping (Swift.Result<Product,Error>) -> Void) {
        let data = [
            "funcion": Routes.getProductDetail,
            "id_user": UserManagement.shared.id_user!,
            "id_product": productId
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
                  let decoded = try? JSONDecoder().decode(ProductResponseModel.self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded.info))
        }
    }
    
    static func fetchFavorites(completion: @escaping (Swift.Result<[FavoriteProduct],Error>) -> Void) {
        let data = [
            "funcion": Routes.getFavorites,
            "id_user": UserManagement.shared.id_user!
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
                  let decoded = try? JSONDecoder().decode([FavoriteProduct].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func updateFavorite(id_product: String, status: String, completion: @escaping(Result) -> Void){
        let data = [
            "funcion": Routes.adminFavorite,
            "id_user": UserManagement.shared.id_user!,
            "id_product": id_product,
            "active": status
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
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

