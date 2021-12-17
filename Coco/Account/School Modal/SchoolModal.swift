//
//  SchoolModal.swift
//  Coco
//
//  Created by Carlos Banos on 7/8/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField

protocol SchoolModalDelegate {
  func didSelectSchool(index: Int)
}

class SchoolModal: UIViewController {
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var schoolField: SkyFloatingLabelTextField!
  
  var delegate: SchoolModalDelegate!
  let dropdown = DropDown()
  var schools: Schools!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureDropdown()
  }
  
  private func configureView() {
    backView.roundCorners(15)
    schoolField.delegate = self
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
  
  func showInView(aView: UIView!, animated: Bool) {
    aView.addSubview(self.view)
    if animated {
      self.showAnimate()
    }
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
  
  private func configureDropdown() {
    var dropdownTitle = [String]()
    for element in schools.schools {
      dropdownTitle.append(element.name ?? "")
    }
    dropdown.anchorView = schoolField
    dropdown.bottomOffset = CGPoint(x: 0, y: schoolField.bounds.height)
    dropdown.direction = .bottom
    dropdown.dataSource = dropdownTitle
    dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.schoolField.text = item
      self.delegate.didSelectSchool(index: index)
      self.dropdown.hide()
    }
  }
}

extension SchoolModal: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    dropdown.show()
    return false
  }
}
