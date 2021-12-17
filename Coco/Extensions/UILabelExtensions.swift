//
//  UILabelExtensions.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
extension UILabel {
  func setUpLabel(text: String, fontSize: CGFloat) {
    self.text = text
    font = UIFont(name: "MyriadPro-Bold", size: fontSize)
  }
}

class LabelPadding: UILabel {
  let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + 16,
                  height: size.height + 0)
  }
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
