// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let giftDetailMain = try? newJSONDecoder().decode(giftDetailMain.self, from: jsonData)

import Foundation

// MARK: - giftDetailMain
class giftDetailMain: Codable {
    let state, statusMsg: String?
    let data: giftDetailData?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg
        case data
    }

    init(state: String?, statusMsg: String?, data: giftDetailData?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - giftDetailData
class giftDetailData: Codable {
    let info: giftDetailInfo?
    let products: [giftDetailProduct]?

    init(info: giftDetailInfo?, products: [giftDetailProduct]?) {
        self.info = info
        self.products = products
    }
}

// MARK: - giftDetailInfo
class giftDetailInfo: Codable {
    let id, monto, procentajePropina, montoPropina: String?
    let nombre, comentarios, total: String?
    let imagen: String?
    let fecha, estatus, tipoCompra, montoCocopoints: String?
    let alumnoRegalo, mensajeAmigo: String?
    let fechaCanje: String?

    enum CodingKeys: String, CodingKey {
        case id
        case monto
        case procentajePropina
        case montoPropina
        case nombre, comentarios, total, imagen, fecha, estatus
        case tipoCompra
        case montoCocopoints
        case alumnoRegalo
        case mensajeAmigo
        case fechaCanje
    }

    init(id: String?, monto: String?, procentajePropina: String?, montoPropina: String?, nombre: String?, comentarios: String?, total: String?, imagen: String?, fecha: String?, estatus: String?, tipoCompra: String?, montoCocopoints: String?, alumnoRegalo: String?, mensajeAmigo: String?, fechaCanje: String?) {
        self.id = id
        self.monto = monto
        self.procentajePropina = procentajePropina
        self.montoPropina = montoPropina
        self.nombre = nombre
        self.comentarios = comentarios
        self.total = total
        self.imagen = imagen
        self.fecha = fecha
        self.estatus = estatus
        self.tipoCompra = tipoCompra
        self.montoCocopoints = montoCocopoints
        self.alumnoRegalo = alumnoRegalo
        self.mensajeAmigo = mensajeAmigo
        self.fechaCanje = fechaCanje
    }
}

// MARK: - giftDetailProduct
class giftDetailProduct: Codable {
    let id, nombre, cantidad, precio: String?
    let precioTotal: String?
    let imagen: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nombre, cantidad, precio
        case precioTotal
        case imagen
    }

    init(id: String?, nombre: String?, cantidad: String?, precio: String?, precioTotal: String?, imagen: String?) {
        self.id = id
        self.nombre = nombre
        self.cantidad = cantidad
        self.precio = precio
        self.precioTotal = precioTotal
        self.imagen = imagen
    }
}
