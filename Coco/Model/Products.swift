//
//  Products.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Foundation

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
    public var cocopoints: Double?
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
                cocopoints: Double = 0,
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


struct ProducListresponse : Codable {
    let state : String?
    let status_msg : String?
    let data : [ProducItem]?
    
    enum Keys : String, CodingKey {
        case state = "state"
        case status_msg = "status_msg"
        case data = "data"
    }
    
    init(from decoder : Decoder) throws{
        let value = try decoder.container(keyedBy: Keys.self)
        state = try value.decodeIfPresent(String.self, forKey: .state)
        status_msg = try value.decodeIfPresent(String.self, forKey: .status_msg)
        if let lista = try value.decodeIfPresent([ProducItem].self, forKey: .data){
            data = lista
        }
        else {
            data = [ProducItem]()
        }
    }
    init(mensaje : String){
        state = ""
        status_msg = mensaje
        data = []
    }
}

struct ProducItem : Codable {
    public var id: String?
    public var cocopoints: Double?
    public var description: String?
    public var id_store: String?
    public var imageURL: String?
    public var name: String?
    public var price: String?
    public var proveedor : String?
    public var favorite : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case cocopoints = "cocopoints"
        case description = "descripcion"
        case id_store = "id_store"
        case imageURL = "imagen"
        case name = "nombre"
        case price = "precio"
        case proveedor = "proveedor"
        case favorite = "favorite"
    }
    
    init(from decoder:Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decodeIfPresent(String.self, forKey: .id) ?? ""
        cocopoints = try value.decodeIfPresent(Double.self, forKey: .cocopoints) ?? 0
        description = try value.decodeIfPresent(String.self, forKey: .description) ?? ""
        id_store = try value.decodeIfPresent(String.self, forKey: .id_store) ?? ""
        imageURL = try value.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        name = try value.decodeIfPresent(String.self, forKey: .name) ?? ""
        price = try value.decodeIfPresent(String.self, forKey: .price) ?? ""
        favorite = try value.decodeIfPresent(String.self, forKey: .favorite) ?? ""
    }
}

//_-------------------------


struct DataItem : Codable {
    var info : ProducItem?
    var ingredients : [IngredienteItem]?
    var extras : [extraItem]?
    var options_1 : [OptionItem]?
    var number_options_1 : [numberOption1Item]?
    
    var options_2 : [OptionItem]?
    var number_options_2 : [numberOption2Item]?
    
    enum keys: String, CodingKey {
        case info = "info"
        case ingredients = "ingredients"
        case extras = "extras"
        case options_1 = "options_1"
        case number_options_1 = "number_options_1"
        case options_2 = "options_2"
        case number_options_2 = "number_options_2"
    }
    
    init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: keys.self)
        info = try value.decodeIfPresent(ProducItem.self, forKey: keys.info)
        if let lista = try value.decodeIfPresent([IngredienteItem].self, forKey: keys.ingredients) {
            ingredients = lista
        }
        else{
            ingredients = [IngredienteItem]()
        }
        
        if let listaExtras = try value.decodeIfPresent([extraItem].self, forKey: keys.extras) {
            extras = listaExtras
        }
        else{
            extras = [extraItem]()
        }
        if let listaOpcion1 = try value.decodeIfPresent([OptionItem].self, forKey: keys.options_1) {
            options_1 = listaOpcion1
        }
        else{
            options_1 = [OptionItem]()
        }
        
        if let numberOpcion1 = try value.decodeIfPresent([numberOption1Item].self, forKey: keys.number_options_1) {
            number_options_1 = numberOpcion1
        }
        else{
            number_options_1 = [numberOption1Item]()
        }
        if let listaOpcion2 = try value.decodeIfPresent([OptionItem].self, forKey: keys.options_2) {
            options_2 = listaOpcion2
        }
        else{
            options_2 = [OptionItem]()
        }
        if let numberOpcion2 = try value.decodeIfPresent([numberOption2Item].self, forKey: keys.number_options_2) {
            number_options_2 = numberOpcion2
        }
        else{
            number_options_2 = [numberOption2Item]()
        }
    }
    
    
}

struct numberOption2Item : Codable {
    var selectable_options_2 : String?
    var etiqueta : String?
    
    enum keys: String, CodingKey {
        case selectable_options_2 = "selectable_options_2"
        case etiqueta = "etiqueta"
    }
    init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: keys.self)
        selectable_options_2 = try value.decodeIfPresent(String.self, forKey: keys.selectable_options_2)
        etiqueta = try value.decodeIfPresent(String.self, forKey: keys.etiqueta)
    }
}

struct numberOption1Item : Codable {
    var selectable_options_1 : String?
    var etiqueta : String?
    
    enum keys: String, CodingKey {
        case selectable_options_1 = "selectable_options_1"
        case etiqueta = "etiqueta"
    }
    init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: keys.self)
        selectable_options_1 = try value.decodeIfPresent(String.self, forKey: keys.selectable_options_1)
        etiqueta = try value.decodeIfPresent(String.self, forKey: keys.etiqueta)
    }
}

struct OptionItem : Codable{
    var id_options : String?
    var name : String?
    var price : String?
    
    enum keys: String, CodingKey {
        case id_options = "id_options"
        case name = "name"
        case price = "price"
    }
    
    init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: keys.self)
        id_options = try value.decodeIfPresent(String.self, forKey: keys.id_options)
        name = try value.decodeIfPresent(String.self, forKey: keys.name)
        price = try value.decodeIfPresent(String.self, forKey: keys.price)
    }
}

struct extraItem : Codable {
    var id_extra : String?
    var name : String?
    var price : String?
    
    enum keys: String, CodingKey {
        case id_extra = "id_extra"
        case name = "name"
        case price = "price"
    }
    
    init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: keys.self)
        id_extra = try value.decodeIfPresent(String.self, forKey: keys.id_extra)
        name = try value.decodeIfPresent(String.self, forKey: keys.name)
        price = try value.decodeIfPresent(String.self, forKey: keys.price)
    }
    
}

struct IngredienteItem : Codable {
    var id_ingredient : String?
    var name : String?
    
    enum keys: String, CodingKey {
        case id_ingredient = "id_ingredient"
        case name = "name"
    }
    
    init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: keys.self)
        id_ingredient = try value.decodeIfPresent(String.self, forKey: keys.id_ingredient)
        name = try value.decodeIfPresent(String.self, forKey: keys.name)
    }
}

struct ProducDetailResponse : Codable {
    let state : String?
    let status_msg : String?
    let data : DataItem?
    
    enum Keys : String, CodingKey {
        case state = "state"
        case status_msg = "status_msg"
        case data = "data"
    }
    
    init(from decoder : Decoder) throws{
        let value = try decoder.container(keyedBy: Keys.self)
        state = try value.decodeIfPresent(String.self, forKey: .state)
        status_msg = try value.decodeIfPresent(String.self, forKey: .status_msg)
        data = try value.decodeIfPresent(DataItem.self, forKey: .data)
        /*
        if let lista = try value.decodeIfPresent([ProducItem].self, forKey: .data){
            data = lista
        }
        else {
            data = [ProducItem]()
        }*/
    }
    
    init(mensaje : String) {
        state = ""
        status_msg = mensaje
        data = nil
    }
}
