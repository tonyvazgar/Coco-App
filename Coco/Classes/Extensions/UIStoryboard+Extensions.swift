//
//  UIStoryboard+Extensions.swift
//  Coco
//
//  Created by Carlos Banos on 9/28/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation

extension UIStoryboard {
    /** Global */
    public static var tabBar: UIStoryboard { UIStoryboard(name: "TabBar", bundle: nil) }
    public static var sideMenu: UIStoryboard { UIStoryboard(name: "SideMenu", bundle: nil) }
    public static var main: UIStoryboard { UIStoryboard(name: "Main", bundle: nil) }
    
    /** Tab bar */
    public static var home: UIStoryboard { UIStoryboard(name: "Home", bundle: nil) }
    public static var payments: UIStoryboard { UIStoryboard(name: "Payments", bundle: nil) }
    
    /** More menu */
    public static var accounts: UIStoryboard { UIStoryboard(name: "Account", bundle: nil) }
    public static var banner: UIStoryboard { UIStoryboard(name: "Banner", bundle: nil) }
    public static var help: UIStoryboard { UIStoryboard(name: "Help", bundle: nil) }
    public static var deposits: UIStoryboard { UIStoryboard(name: "Deposits", bundle: nil) }
    public static var favorites: UIStoryboard { UIStoryboard(name: "Favorites", bundle: nil) }
    public static var settings: UIStoryboard { UIStoryboard(name: "Settings", bundle: nil) }
    
    /** Products */
    public static var products: UIStoryboard { UIStoryboard(name: "Products", bundle: nil) }
    public static var profile: UIStoryboard { UIStoryboard(name: "Profile", bundle: nil) }
    
    /** Shopping Cart */
    public static var shoppingCart: UIStoryboard { UIStoryboard(name: "ShoppingCart", bundle: nil) }
    public static var pickups: UIStoryboard { UIStoryboard(name: "Pickups", bundle: nil) }
    
    public static var orders: UIStoryboard { UIStoryboard(name: "Orders", bundle: nil) }
    
    public func instantiate<A: UIViewController>(_ type: A.Type, withIdentifier identifier: String? = nil) -> A {
        let id = identifier ?? String(describing: type.self)
        guard let vc = self.instantiateViewController(withIdentifier: id) as? A else {
            fatalError("Could not instantiate view controller \(A.self)") }
        return vc
    }
}
