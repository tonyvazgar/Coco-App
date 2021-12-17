//
//  UIViewExtensions.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import Kingfisher

extension UIView {
  func circleBorders() {
    layer.cornerRadius = layer.frame.width / 2
    clipsToBounds = true
  }
  
  func addBorder(thickness: CGFloat = 1, color: UIColor = .black) {
    layer.borderColor = color.cgColor
    layer.borderWidth = thickness
  }
  
  func addTap(_ selector: Selector, tapHandler target: Any = self) {
    let tap = UITapGestureRecognizer()
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    tap.addTarget(target, action: selector)
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
  
  func addShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.darkGray.cgColor
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize.zero
    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
  }
  
  func addBottomShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.05
    layer.masksToBounds = false
  }
  
  func addTopShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: -3)
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.05
    layer.masksToBounds = false
  }
  
  func roundCorners(_ value: CGFloat, clipToBounds: Bool = true) {
    layer.cornerRadius = value
    clipsToBounds = clipToBounds
  }
  
  func setShadow(color: UIColor = UIColor.darkGray, cornerRadius: CGFloat = 8) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 5
    layer.shadowOpacity = 0.5
    layer.shouldRasterize  = true
    layer.rasterizationScale = UIScreen.main.scale
    layoutIfNeeded()
  }
  
  func updateShadow() {
    layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).cgPath
  }
  
  func addBottomBorder(thickness: CGFloat, color: UIColor) {
    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
    layer.backgroundColor = color.cgColor
    self.layer.addSublayer(layer)
  }
}
