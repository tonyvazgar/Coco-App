// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stuff = try? newJSONDecoder().decode(Stuff.self, from: jsonData)

import Foundation

// MARK: - Stuff
class Stuff: Codable {
    let state, statusMsg: String?
    let data: DataClass23?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg = "status_msg"
        case data
    }

    init(state: String?, statusMsg: String?, data: DataClass23?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - DataClass
class DataClass23: Codable {
    let tiempoEstimado: Int?
    let cocos: Int?
    enum CodingKeys: String, CodingKey {
        case tiempoEstimado = "TiempoEstimado"
        case cocos = "Cocopoints"
    }

    init(tiempoEstimado: Int?, cocos: Int?) {
        self.tiempoEstimado = tiempoEstimado
        self.cocos = cocos
    }
}
