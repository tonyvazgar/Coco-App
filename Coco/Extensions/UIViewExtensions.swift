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

extension UIView {
   
    enum Visibility: String {
        case visible = "visible"
        case invisible = "invisible"
        case gone = "gone"
    }
   
    var visibility: Visibility {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visibility != newValue {
                self.setVisibility(newValue)
            }
        }
    }
   
    @IBInspectable
    var visibilityState: String {
        get {
            return self.visibility.rawValue
        }
        set {
            let _visibility = Visibility(rawValue: newValue)!
            self.visibility = _visibility
        }
    }
   
    private func setVisibility(_ visibility: Visibility) {
        let constraints = self.constraints.filter({$0.firstAttribute == .height && $0.constant == 0 && $0.secondItem == nil && ($0.firstItem as? UIView) == self})
        let constraint = (constraints.first)
       
        switch visibility {
        case .visible:
            constraint?.isActive = false
            self.isHidden = false
            break
        case .invisible:
            constraint?.isActive = false
            self.isHidden = true
            break
        case .gone:
            self.isHidden = true
            if let constraint = constraint {
                constraint.isActive = true
            } else {
                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                // constraint.priority = UILayoutPriority(rawValue: 999)
                self.addConstraint(constraint)
                constraint.isActive = true
            }
            self.setNeedsLayout()
            self.setNeedsUpdateConstraints()
        }
    }
}
