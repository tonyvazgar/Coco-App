//
//  UIImageViewExtensions.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
  func setImageKf(str: String){
    if let url = URL(string: str) {
      if UIApplication.shared.canOpenURL(url) {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.kf.setImage(with: url,
                         placeholder: nil,
                         options: [.transition(.fade(0.4))],
                         progressBlock: nil,
                         completionHandler: nil)
      }
    }
  }
  
  func setImage(str: String, placeholder: UIImage? = nil){
    self.contentMode = .scaleAspectFill
    if let aux = UIImage(named: str){
      self.image = aux
    }
  }
}

