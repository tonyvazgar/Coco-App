//
//  Constatns.swift
//  Coco
//
//  Created by Erick Monfil on 03/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import Foundation
import UIKit
struct Constatns {
    struct Conekta {
        static let publickKeyProductive = "key_WiYPtYGfzTwZFWV7yVXm6qA"
        static let publickKeyDevelop = "key_CLYZkCgpss3hHwqp1k5XfCw"
    }
    struct LocalData {
        
        struct paymentCanasta {
            static var numeroTarjeta : String {
                get {
                    return UserDefaults.standard.string(forKey: "numeroTarjeta") ?? ""
                }
                set(pago){
                    UserDefaults.standard.set(pago, forKey: "numeroTarjeta")
                    UserDefaults.standard.synchronize()
                }
            }
            static var forma_pago : Int {
                get {
                    return UserDefaults.standard.integer(forKey: "forma_pago") ?? 0
                }
                set(pago){
                    UserDefaults.standard.set(pago, forKey: "forma_pago")
                    UserDefaults.standard.synchronize()
                }
            }
            static var token_cliente : String {
                get {
                    return UserDefaults.standard.string(forKey: "token_cliente") ?? ""
                }
                set(tc){
                    UserDefaults.standard.set(tc, forKey: "token_cliente")
                    UserDefaults.standard.synchronize()
                }
            }
            
            static var token_card : String {
                get {
                    return UserDefaults.standard.string(forKey: "token_card") ?? ""
                }
                set(tc){
                    UserDefaults.standard.set(tc, forKey: "token_card")
                    UserDefaults.standard.synchronize()
                }
            }
            static var token_id : String {
                get {
                    return UserDefaults.standard.string(forKey: "token_id") ?? ""
                }
                set(tc){
                    UserDefaults.standard.set(tc, forKey: "token_id")
                    UserDefaults.standard.synchronize()
                }
            }
            static var tipoTarjeta : String {
                get {
                    return UserDefaults.standard.string(forKey: "tipoTarjeta") ?? ""
                }
                set(tipo){
                    UserDefaults.standard.set(tipo, forKey: "tipoTarjeta")
                    UserDefaults.standard.synchronize()
                }
            }
            
        }
        
        static var canasta : Data? {
            get {
                return UserDefaults.standard.data(forKey: "canasta") ?? nil
            }
            set(canasta){
                UserDefaults.standard.set(canasta, forKey: "canasta")
                UserDefaults.standard.synchronize()
            }
        }
        
        
        
        static var metodoPickup : Int {
            get {
                return UserDefaults.standard.integer(forKey: "metodoPickup") ?? 0
            }
            set(token){
                UserDefaults.standard.set(token, forKey: "metodoPickup")
                UserDefaults.standard.synchronize()
            }
        }
        
        static var marcaCarro : String {
            get {
                return UserDefaults.standard.string(forKey: "marcaCarro") ?? ""
            }
            set(token){
                UserDefaults.standard.set(token, forKey: "marcaCarro")
                UserDefaults.standard.synchronize()
            }
        }
        
        static var colorCarro : String {
            get {
                return UserDefaults.standard.string(forKey: "colorCarro") ?? ""
            }
            set(token){
                UserDefaults.standard.set(token, forKey: "colorCarro")
                UserDefaults.standard.synchronize()
            }
        }
        
        static var placasCarro : String {
            get {
                return UserDefaults.standard.string(forKey: "placasCarro") ?? ""
            }
            set(token){
                UserDefaults.standard.set(token, forKey: "placasCarro")
                UserDefaults.standard.synchronize()
            }
        }
        static var comentarios : String {
            get {
                return UserDefaults.standard.string(forKey: "comentarios") ?? ""
            }
            set(token){
                UserDefaults.standard.set(token, forKey: "comentarios")
                UserDefaults.standard.synchronize()
            }
        }
        
        static var aceptaPropina : String {
            get {
                return UserDefaults.standard.string(forKey: "aceptaPropina") ?? "true"
            }
            set(propina){
                UserDefaults.standard.set(propina, forKey: "aceptaPropina")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    
}
