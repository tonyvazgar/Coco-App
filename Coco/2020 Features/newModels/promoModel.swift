// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let promo = try? newJSONDecoder().decode(Promo.self, from: jsonData)

import Foundation

// MARK: - Promo
class Promo: Codable {
    var state, statusMsg: String?
    var data: DataClass?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg
        case data
    }

    init(state: String?, statusMsg: String?, data: DataClass?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - DataClass
class DataClass: Codable {
    var info: Info?
    var tiendas: [Tienda]?
    var promocion: Promocion?
    var ultimoPedido: Int?
    var alumnos: [Alumno]?
    var regalo: Int?

    enum CodingKeys: String, CodingKey {
        case info, tiendas, promocion
        case ultimoPedido
        case alumnos, regalo
    }

    init(info: Info?, tiendas: [Tienda]?, promocion: Promocion?, ultimoPedido: Int?, alumnos: [Alumno]?, regalo: Int?) {
        self.info = info
        self.tiendas = tiendas
        self.promocion = promocion
        self.ultimoPedido = ultimoPedido
        self.alumnos = alumnos
        self.regalo = regalo
    }
}

// MARK: - Alumno
class Alumno: Codable {
    var Id, nombre: String?

    enum CodingKeys: String, CodingKey {
        case Id
        case nombre
    }

    init(Id: String?, nombre: String?) {
        self.Id = Id
        self.nombre = nombre
    }
}

// MARK: - Info
class Info: Codable {
    var nombre, apellidos, notificaciones, saldoActual: String?
    var saldoCocopoints, codigoReferido: String?

    enum CodingKeys: String, CodingKey {
        case nombre, apellidos, notificaciones
        case saldoActual
        case saldoCocopoints
        case codigoReferido
    }

    init(nombre: String?, apellidos: String?, notificaciones: String?, saldoActual: String?, saldoCocopoints: String?, codigoReferido: String?) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.notificaciones = notificaciones
        self.saldoActual = saldoActual
        self.saldoCocopoints = saldoCocopoints
        self.codigoReferido = codigoReferido
    }
}

// MARK: - Promocion
class Promocion: Codable {
    var id, titulo, descripcion: String?
    var imagen: String?
    var link: String?

    enum CodingKeys: String, CodingKey {
        case id
        case titulo, descripcion, imagen, link
    }

    init(id: String?, titulo: String?, descripcion: String?, imagen: String?, link: String?) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.imagen = imagen
        self.link = link
    }
}

// MARK: - Tienda
class Tienda: Codable {
    var id, nombre, horario: String?
    var imagen: String?
    var direccion: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nombre, horario, imagen, direccion
    }

    init(id: String?, nombre: String?, horario: String?, imagen: String?, direccion: String?) {
        self.id = id
        self.nombre = nombre
        self.horario = horario
        self.imagen = imagen
        self.direccion = direccion
    }
}
