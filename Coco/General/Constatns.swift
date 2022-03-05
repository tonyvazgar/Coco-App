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
    struct LocalData {
        
        static var canasta : Data? {
            get {
                return UserDefaults.standard.data(forKey: "canasta") ?? nil
            }
            set(canasta){
                UserDefaults.standard.set(canasta, forKey: "canasta")
                UserDefaults.standard.synchronize()
            }
        }
    }
}
