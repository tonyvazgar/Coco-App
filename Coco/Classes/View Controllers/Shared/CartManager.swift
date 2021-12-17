//
//  CartManager.swift
//  Coco
//
//  Created by Carlos Banos on 11/10/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation

final class CartManager {
    static let instance = CartManager()
    
    var cart: ShoppingCart? = {
        if let cart = UserDefaults.standard.data(forKey: "shoppingCart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(ShoppingCart.self, from: cart) {
                return decoded
            }
        }
        return nil
    }()
    
    
    var totalItems: Int {
        cart?.products.count ?? 0
    }
    
    var itemCount: String? {
        guard let count = cart?.products.count else { return nil }
        return count == 0 ? nil : "\(count)"
    }
    
    func emptyCart() {
        cart = nil
        UserDefaults.standard.removeObject(forKey: "shoppingCart")
        NotificationCenter.default.post(name: .cartDidChange, object: nil)
    }
    
    func addToCart(location: LocationsDataModel?, product: Product, quantity: Int) -> Bool {
        if cart != nil {
            if cart?.id_store == product.id_store {
                if let cartProduct = cart?.products.first(where: { $0.id == product.id }),
                   let qty = cartProduct.quantity, let qtyInt = Int(qty) {
                    product.quantity = "\(min((qtyInt + quantity), 10))"
                } else {
                    product.quantity = "\(quantity)"
                }
                cart!.addProduct(product: product, location: location)
            } else {
                cart = ShoppingCart(id_store: product.id_store, store_name: product.business)
                product.quantity = "\(quantity)"
                cart!.addProduct(product: product, location: location)
            }
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
                return true
            }
        } else {
            cart = ShoppingCart(id_store: product.id_store, store_name: product.business)
            product.quantity = "\(quantity)"
            cart!.addProduct(product: product, location: location)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
                return true
            }
        }
        return false
    }
    
    func setProductToCart(location: LocationsDataModel?, product: Product, quantity: Int) -> Bool {
        if cart != nil {
            if cart?.id_store == product.id_store {
                product.quantity = "\(quantity)"
                cart!.addProduct(product: product, location: location)
            } else {
                cart = ShoppingCart(id_store: product.id_store, store_name: product.business)
                product.quantity = "\(quantity)"
                cart!.addProduct(product: product, location: location)
            }
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
                return true
            }
        } else {
            cart = ShoppingCart(id_store: product.id_store, store_name: product.business)
            product.quantity = "\(quantity)"
            cart!.addProduct(product: product, location: location)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(cart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
                return true
            }
        }
        return false
    }
    
    func updateQuantity(product: Product, quantity: Int) {
        product.quantity = "\(quantity)"
        cart?.addProduct(product: product)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cart) {
            UserDefaults.standard.set(encoded, forKey: "shoppingCart")
            NotificationCenter.default.post(name: .cartDidChange, object: nil)
        }
    }
}
