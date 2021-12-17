//
//  UIFont+Extensions.swift
//  Coco
//
//  Created by Carlos Banos on 9/28/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

enum PoppinsFont: String {
    case bold = "Poppins-Bold"
    case extraBold = "Poppins-ExtraBold"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
    case medium = "Poppins-Medium"
}

extension UIFont {
    static func poppins(type: PoppinsFont, size: CGFloat) -> UIFont {
        UIFont(name: type.rawValue, size: size)!
    }
}
