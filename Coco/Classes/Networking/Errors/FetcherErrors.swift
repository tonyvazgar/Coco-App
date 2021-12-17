//
//  FetcherErrors.swift
//  Coco
//
//  Created by Carlos Banos on 10/8/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation

enum FetcherErrors: Error {
    case invalidResponse
    case jsonMapping
    case statusCode(String?)
    case jsonDecode
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse: return "Error de conexión"
        case .jsonMapping: return "Error al obtener los datos"
        case .statusCode(let errorMessage):
            return errorMessage ?? "Solicitud incorrecta"
        case .jsonDecode: return "Error al leer los datos"
        }
    }
}
