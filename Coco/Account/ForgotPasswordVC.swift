//
//  ForgotPasswordVC.swift
//  Coco
//
//  Created by Carlos Banos on 8/13/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import UIWindowTransitions
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController {
  
  @IBOutlet private var topBar: UIView!
  @IBOutlet private var emailField: SkyFloatingLabelTextField!
  @IBOutlet private var loginBtn: UIButton!
  
  var loader: LoaderVC!
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    loginBtn.roundCorners(15)
  }
  
  @IBAction private func backBtnAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func loginBtnAction(_ sender: Any) {
    guard let email = emailField.text else { return }
    if email == "" {
      emailField.errorMessage = "Email"
      return
    } else {
      emailField.errorMessage = ""
    }
    
    emailField.resignFirstResponder()
    
    showLoader(&loader, view: view)
    
    user = User(email: email)
    
    user.forgotPasswordRequest { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        let alert = AlertModal()
        self.addChild(alert)
        alert.showInView(aView: self.view, text: "Se ha enviado un correo para restablecer su contraseña")
      }
    }
  }
}
