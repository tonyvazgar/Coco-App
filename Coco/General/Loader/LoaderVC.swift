//
//  LoaderVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import Lottie

class LoaderVC: UIViewController {
  
  @IBOutlet weak var viewLoader: UIView!
  
  private var loaderAnimation: AnimationView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    setUpAnimation()
  }
  
  private func setUpAnimation() {
    loaderAnimation = AnimationView(name: "loader")
    loaderAnimation.frame = CGRect(origin: .zero, size: viewLoader.frame.size)
    loaderAnimation.backgroundColor = .clear
    loaderAnimation.loopMode = .loop
    loaderAnimation.animationSpeed = 1
    viewLoader.addSubview(loaderAnimation)
  }
  
  private func showAnimate() {
    view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    view.alpha = 0.0;
    UIView.animate(withDuration: 0.25, animations: {
      self.view.alpha = 1.0
      self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      self.loaderAnimation.play()
    });
  }
  
  func showInView(aView: UIView!, animated: Bool) {
    aView.addSubview(self.view)
    view.frame = CGRect(origin: .zero, size: aView.frame.size)
    if animated {
      self.showAnimate()
    }
  }
  
  func removeAnimate() {
    UIView.animate(withDuration: 0.25, animations: {
//      self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      self.view.alpha = 0.0;
    }, completion:{(finished : Bool)  in
      if (finished) {
        self.view.removeFromSuperview()
      }
    })
  }
}
