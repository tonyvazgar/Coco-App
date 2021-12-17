//
//  LocationsDataModel.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class LocationsDataModel: Codable {
    public var id: String?
    public var name: String?
    public var schedule: String?
    public var imgURL: String?
    public var address: String?
    public var distance: String?
    public var rating: String?
    
    public init(id: String = "",
                name: String = "",
                schedule: String = "",
                address: String = "",
                distance: String = "",
                rating: String = "",
                imgURL: String = "") {
        self.id = id
        self.name = name
        self.schedule = schedule
        self.address = address
        self.distance = distance
        self.rating = rating
        self.imgURL = imgURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "nombre"
        case schedule = "horario"
        case address = "direccion"
        case distance = "distancia"
        case rating = "valoracion"
        case imgURL = "imagen"
    }
}
