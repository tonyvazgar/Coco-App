//
//  PaymentMethodsFetcher.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class PaymentMethodsFetcher {
    static func fetchPaymentMethods(completion: @escaping (Swift.Result<[PaymentForm],Error>) -> Void) {
        let data = [
            "funcion": Routes.getTokens,
            "id_user": UserManagement.shared.id_user!,
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            print(response.debugDescription)
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
                  let decoded = try? JSONDecoder().decode([PaymentForm].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func fetchCocoCards(completion: @escaping (Swift.Result<[CocoCard],Error>) -> Void) {
        let data = [
            "funcion": Routes.getCocoCards,
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
                  let decoded = try? JSONDecoder().decode([CocoCard].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func fetchDeposits(completion: @escaping (Swift.Result<[Deposit],Error>) -> Void) {
        let data = [
            "funcion": Routes.getPayments,
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
                  let decoded = try? JSONDecoder().decode([Deposit].self, from: object) else {
                completion(.failure(FetcherErrors.jsonDecode))
                return
            }
            completion(.success(decoded))
        }
    }
    
    static func redeemCocoCard(token: String, completion: @escaping (Swift.Result<Void,Error>) -> Void) {
        let data = [
            "funcion": Routes.redeemCocoCard,
            "id_user": UserManagement.shared.id_user!,
            "token": token
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

