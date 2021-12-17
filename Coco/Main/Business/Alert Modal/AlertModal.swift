//
//  AlertModal.swift
//  Coco
//
//  Created by Carlos Banos on 7/8/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class AlertModal: UIViewController {
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var labelText: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    backView.roundCorners(15)
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    view.frame = CGRect(origin: .zero,
                        size: UIScreen.main.bounds.size)
  }
  
  private func showAnimate() {
    view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    view.alpha = 0.0;
    UIView.animate(withDuration: 0.25, animations: {
      self.view.alpha = 1.0
      self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    });
  }
  
  func showInView(aView: UIView!, text: String) {
    aView.addSubview(view)
    view.frame = CGRect(origin: .zero, size: aView.bounds.size)
    labelText.text = text
    showAnimate()
  }
  
  func removeAnimate() {
    UIView.animate(withDuration: 0.25, animations: {
      self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      self.view.alpha = 0.0;
    }, completion:{(finished : Bool)  in
      if (finished) {
        self.view.removeFromSuperview()
      }
    })
  }
  
  @IBAction func backBtn(_ sender: Any) {
    removeAnimate()
  }
}
