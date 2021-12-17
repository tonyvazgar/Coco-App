//
//  UIColorExtensions.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

extension UIColor {
  class var CocoGreen: UIColor { return UIColor(named: "Green")! }
  class var CocoBlack: UIColor { return UIColor(named: "Black")! }
  class var CocoBlue: UIColor { return UIColor(named: "Blue")! }
  class var CocoPink: UIColor { return UIColor(named: "Division")! }
  class var CocoSalmon: UIColor { return UIColor(named: "Salmon")! }
  
  class var OpacityGreen: UIColor { return UIColor(named: "Green")!.withAlphaComponent(0.4) }
  class var OpacityOrange: UIColor { return UIColor(named: "Orange")!.withAlphaComponent(0.4) }
}
