//
//  UITextFieldExtensions.swift
//  Coco
//
//  Created by Carlos Banos on 7/19/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
private var __maxLengths = [UITextField: Int]()
extension UITextField {
  @IBInspectable var maxLength: Int {
    get {
      guard let l = __maxLengths[self] else {
        return 150 // (global default-limit. or just, Int.max)
      }
      return l
    }
    set {
      __maxLengths[self] = newValue
      addTarget(self, action: #selector(fix), for: .editingChanged)
    }
  }
  @objc func fix(textField: UITextField) {
    let t = textField.text
    textField.text = t?.safelyLimitedTo(length: maxLength)
  }
}

extension String
{
  func safelyLimitedTo(length n: Int)->String {
    if (self.count <= n) {
      return self
    }
    return String( Array(self).prefix(upTo: n) )
  }
}
