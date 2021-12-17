// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newUserMain = try? newJSONDecoder().decode(NewUserMain.self, from: jsonData)

import Foundation

// MARK: - NewUserMain
class NewUserMain: Codable {
    let state, statusMsg: String?
    let data: [Datum666]?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg = "status_msg"
        case data
    }

    init(state: String?, statusMsg: String?, data: [Datum666]?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - Datum
class Datum666: Codable {
    let id, monto, propina: String?
    let nombre: Nombre?
    let total: String?
    let imagen: String?
    let fecha: String?
    let estatus: Estatus?
    let tipoCompra, montoCocopoints: String?
    let cocopointsOtorgados: String?
    let tiempoEstimado: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case monto, propina, nombre, total, imagen, fecha, estatus
        case tipoCompra = "tipo_compra"
        case montoCocopoints = "monto_cocopoints"
        case cocopointsOtorgados = "cocopoints_otorgados"
        case tiempoEstimado = "tiempo_estimado"
    }

    init(id: String?, monto: String?, propina: String?, nombre: Nombre?, total: String?, imagen: String?, fecha: String?, estatus: Estatus?, tipoCompra: String?, montoCocopoints: String?, cocopointsOtorgados: String?, tiempoEstimado: Int?) {
        self.id = id
        self.monto = monto
        self.propina = propina
        self.nombre = nombre
        self.total = total
        self.imagen = imagen
        self.fecha = fecha
        self.estatus = estatus
        self.tipoCompra = tipoCompra
        self.montoCocopoints = montoCocopoints
        self.cocopointsOtorgados = cocopointsOtorgados
        self.tiempoEstimado = tiempoEstimado
    }
}
