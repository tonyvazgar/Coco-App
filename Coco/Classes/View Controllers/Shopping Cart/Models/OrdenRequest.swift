//
//  OrdenRequest.swift
//  Coco
//
//  Created by Erick Monfil on 03/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import Foundation


struct OrdenRequest : Codable {
    var funcion : String
    var id_user : String
    var sub_amount : String
    var percentage_service : String
    var amount_service : String
    var amount_final : String
    var id_store : String
    var products : [ProductoCanasta]
    var comments : String
    var pickup : pickupCanasta
    var payment : paymentCanasta
    
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
 
}

struct pickupCanasta : Codable {
    var id : String
    var marca : String
    var color : String
    var placas : String
}
struct paymentCanasta : Codable {
    var forma_pago : String
    var token_cliente : String
    var token_card : String
    var new_card : [new_cardCanasta]
}

struct  new_cardCanasta : Codable {
    var nombre : String
    var card_number : String
    var date_expiration : String
    var cvv : String
    
}
struct ProductoCanasta : Codable {
    var id : String
    var cantidad : String
    var precio : String
    var ingredients : [IngredienteCanasta]
    var extras : [ExtraCanasta]
    var options_1 : [options_1Canasta]
    var options_2 : [options_1Canasta]
    
    
}

struct options_1Canasta : Codable {
    var id_options : String
    var id_product : String
    var price : String
}
struct ExtraCanasta : Codable {
    var id_extra : String
    var id_product : String
    var price : String
    var qty : String
}
struct IngredienteCanasta : Codable {
    var id_ingredient : String
}
