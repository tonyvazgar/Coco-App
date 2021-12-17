//
//  LoginVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import UIWindowTransitions
import SkyFloatingLabelTextField

class LoginVC: UIViewController {
    
    @IBOutlet private weak var topBar: UIView!
    @IBOutlet private weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet private weak var loginBtn: UIButton!
    
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func loginBtnAction(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        var completed = true
        if email == "" {
            emailField.errorMessage = "Email"
            completed = false
        } else {
            emailField.errorMessage = ""
        }
        if password == "" {
            passwordField.errorMessage = "Password"
            completed = false
        } else {
            passwordField.errorMessage = ""
        }
        
        if !completed { return }
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        showLoader(&loader, view: view)
        
        user = User(email: email, password: password)
        
        user.loginRequest { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.performSuccessLogin()
            }
        }
    }
    
    private func performSuccessLogin() {
        guard let id = user.id else { return }
        UserDefaults.standard.set(id, forKey: "id_user")
        let vc = instantiate(viewControllerClass: MainController.self)
        let wnd = UIApplication.shared.keyWindow
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        options.duration = 0.4
        options.style = .easeOut
        wnd?.setRootViewController(vc, options: options)
    }
}
