//
//  UserManagement.swift
//  Coco
//
//  Created by Carlos Banos on 9/28/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

final class UserManagement {
    static let shared = UserManagement()
    
    var user: UserMain?
    
    var id_user: String? {
        UserDefaults.standard.string(forKey: "id_user")
    }
    
    var email_user: String? {
        UserDefaults.standard.string(forKey: "email_user")
    }
    
    var token: String? {
        UserDefaults.standard.string(forKey: "token")
    }
    
    var token_saved: Bool {
        UserDefaults.standard.bool(forKey: "token_saved")
    }
    
    func sessionEnd() {
        UserDefaults.standard.removeObject(forKey: "id_user")
        UserDefaults.standard.removeObject(forKey: "email_user")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "token_saved")
        
        Constatns.LocalData.paymentCanasta.numeroTarjeta = ""
        Constatns.LocalData.paymentCanasta.forma_pago = 0
        Constatns.LocalData.paymentCanasta.token_cliente = ""
        Constatns.LocalData.paymentCanasta.token_card = ""
        Constatns.LocalData.paymentCanasta.token_id = ""
        Constatns.LocalData.paymentCanasta.tipoTarjeta = ""
        Constatns.LocalData.canasta = nil
        Constatns.LocalData.metodoPickup = 0
        Constatns.LocalData.marcaCarro = ""
        Constatns.LocalData.colorCarro = ""
        Constatns.LocalData.placasCarro = ""
        Constatns.LocalData.comentarios = ""
        Constatns.LocalData.aceptaPropina = ""
        Constatns.LocalData.tipoPickUpAceptados = ""
        
        let tipo = ProviderType(rawValue: Constatns.LocalData.tipoLogin)
        switch tipo {
        case .email:
            break
        case .invitado :
            break
        case .google:
            do {
                GIDSignIn.sharedInstance.signOut()
                try Auth.auth().signOut()
            }
            catch {
                print("error al hacer logout")
            }
            break
        case .apple :
            do {
                try Auth.auth().signOut()
            }
            catch {
                print("error al hacer logout")
            }
            break
        default :
            break
        }
        //aca cerra la sesion dependiendo el tipo de login
        
        
    }
}
