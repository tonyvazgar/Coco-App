//
//  CocoCard.swift
//  Coco
//
//  Created by Carlos Banos on 2/19/21.
//  Copyright © 2021 Easycode. All rights reserved.
//

import Foundation

class CocoCard: Decodable {
  public var id: String?
  public var amount: String?
  public var redemptionDate: String?
  public var token: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case amount = "monto"
    case redemptionDate = "fecha"
    case token
  }
}
