//
//  Products.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Products: Decodable {
    public var products: [Product] = []
    
    enum CodingKeys: String, CodingKey {
        case products = "data"
    }
    
    func requestProducts(id_category: String, id_business: String, completion: @escaping(Result) -> Void){
        let data = [
            "funcion": Routes.getProducts,
            "id_user": UserManagement.shared.id_user!,
            "id_store": id_business,
            "id_category": id_category
        ]
        
        Alamofire.request(General.url_connection, method: .post, parameters: data).responseJSON { (response) in
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
            
            if dictionary["state"] == "200" {
                
                print(dictionary)
                
            }
            
            guard let object = try? JSON(data).rawData(),
                let decoded = try? JSONDecoder().decode(Products.self, from: object) else {
                    completion(.failure("Error al leer los datos."))
                    return
            }
            self.products = decoded.products
            completion(.success([]))
        }
    }
}

final class ProductResponseModel: Decodable {
    var info: Product
    
    init(product: Product) {
        info = product
    }
}

final class Product: Codable {
    public var id: String?
    public var name: String?
    public var description: String?
    public var imageURL: String?
    public var schedule: String?
    public var price: String?
    public var id_store: String?
    public var favorite: String?
    public var business: String?
    public var quantity: String?
    public var cocopoints: Int?
    public var tiempoEstimado: Int?
    public var cocopointsOtorgados: String?
    
    public init(id: String = "",
                name: String = "",
                description: String = "",
                imageURL: String = "",
                price: String = "",
                id_store: String = "",
                favorite: String = "",
                business: String = "",
                cocopoints: Int = 0,
                tiempoEstimado: Int = 0,
                quantity: String = "",
                cocopointsOtorgados: String = "") {
        
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.id_store = id_store
        self.favorite = favorite
        self.business = business
        self.quantity = quantity
        self.cocopoints = cocopoints
        self.tiempoEstimado = tiempoEstimado
        self.cocopointsOtorgados = cocopointsOtorgados
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "nombre"
        case description = "descripcion"
        case schedule = "horario"
        case imageURL = "imagen"
        case price = "precio"
        case id_store = "id_store"
        case favorite
        case business = "proveedor"
        case quantity = "cantidad"
        case cocopoints = "cocopoints"
        case tiempoEstimado = "tiempo_estimado"
        case cocopointsOtorgados = "cocopoints_otorgados"
    }
    
    func requestProductDetail(completion: @escaping(Result) -> Void){
        let data = [
            "funcion": Routes.getProductDetail,
            "id_user": UserManagement.shared.id_user!,
            "id_product": id ?? ""
        ]
        
        Alamofire.request(General.url_connection, method: .post, parameters: data).responseJSON { (response) in
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary
                else {
                    completion(.failure("Error al obtener los datos"))
                    return
            }
            
            if dictionary["state"] == "200" {
                
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            
            guard let dataDictionary = dictionary["data"],
                let object = try? dataDictionary["info"].rawData(),
                let decoded = try? JSONDecoder().decode(Product.self, from: object) else {
                    completion(.failure("Error al leer los datos"))
                    return
            }
            
            self.name = decoded.name
            self.description = decoded.description
            self.imageURL = decoded.imageURL
            self.price = decoded.price
            self.id_store = decoded.id_store
            self.favorite = decoded.favorite
            self.business = decoded.business
            self.cocopoints = decoded.cocopoints
            self.tiempoEstimado = decoded.tiempoEstimado
            self.cocopointsOtorgados = decoded.cocopointsOtorgados
            completion(.success([]))
        }
    }
    
    func requestStatusFavorite(status: String, completion: @escaping(Result) -> Void){
        let parameters = [
            "funcion": Routes.adminFavorite,
            "id_user": UserManagement.shared.id_user!,
            "id_product": id ?? "",
            "active": status
        ]
        
        Alamofire.request(General.url_connection,
                          method: .post,
                          parameters: parameters).responseJSON { (response) in
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
