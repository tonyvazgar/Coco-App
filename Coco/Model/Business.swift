//
//  Business.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class BusinessesResponseModel: Decodable {
    var info: UserMain?
    var businesses: [Business]
    
    enum CodingKeys: String, CodingKey {
      case info, businesses = "establecimientos"
    }
}

final class Business: Decodable {
    public var id: String?
    public var name: String?
    public var schedule: String?
    public var imgURL: String?
    public var address: String?
    public var distance: String?
    
    public init(id: String = "",
                name: String = "",
                schedule: String = "",
                address: String = "",
                distance: String = "",
                imgURL: String = "") {
        self.id = id
        self.name = name
        self.schedule = schedule
        self.address = address
        self.distance = distance
        self.imgURL = imgURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "nombre"
        case schedule = "horario"
        case address = "direccion"
        case distance = "distancia"
        case imgURL = "imagen"
    }
}
