//
//  UserManagement.swift
//  Coco
//
//  Created by Carlos Banos on 9/28/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation

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
    }
}
