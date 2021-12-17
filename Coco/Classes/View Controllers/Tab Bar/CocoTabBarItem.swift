//
//  CocoTabBarItem.swift
//  Coco
//
//  Created by Carlos Banos on 10/6/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

@IBDesignable
class CocoTabBarItem: UITabBarItem {
    @IBInspectable var icon: UIImage = UIImage() {
        didSet {
            self.image = icon.withRenderingMode(.alwaysOriginal)
        }
    }
    @IBInspectable var selectedIcon: UIImage = UIImage() {
        didSet {
            self.selectedImage = selectedIcon.withRenderingMode(.alwaysOriginal)
        }
    }
    
    override init() {
        super.init()
        configureTextColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextColor()
    }
    
    private func configureTextColor() {
        
        setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.cocoOrange], for: .selected)
    }
    
    
}
