//
//  CityDataModel.swift
//  Coco
//
//  Created by Carlos Banos on 11/10/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation

struct CityDataModel: Codable {
    var id: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id", name = "nombre"
    }
}
