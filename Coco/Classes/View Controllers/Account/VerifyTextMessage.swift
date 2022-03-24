//
//  VerifyTextMessage.swift
//  Coco
//
//  Created by Tony Vazgar on 01/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit


class VerifyTextMessage: UIViewController {
    
    @IBOutlet weak var textMessageField: UITextField!
    @IBOutlet weak var verifyButtonOutlet: UIButton!
    
    
    var loader: LoaderVC!
    var user: User!
    var email : String = ""
    var passwor : String = ""
    @IBAction func verifyButtonAction(_ sender: Any) {
        
        guard let code = validateField(textMessageField) else {
            throwError(str: "Para continuar debes ingresar el código.")
            return
        }
        
        view.resignFirstResponder()
        showLoader(&loader, view: view)
        print("Datos reciidos")
        print("Email:\(email)")
        print("password:\(passwor)")
        user = User()
        
        user.verifyTextMessage(textMessage: code) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self?.throwError(str: errorMssg)
            case .success(_):
                self?.performSuccessVerification()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        verifyButtonOutlet.roundCorners(16)
        configureTextFields()
    }
    
    func configureTextFields() {
        textMessageField.clipsToBounds = true
        textMessageField.addBottomBorder(thickness: 1, color: .lightGray)
    }
    
    private func validateField(_ textField: UITextField) -> String? {
        (textField.text?.isEmpty ?? true) ? nil : textField.text
    }
    
    private func performSuccessVerification() {
        
        signIn(with: self.email, password: self.passwor)
        /*
        let alert = UIAlertController()
        alert.title = "Cuenta creada con éxito"
        alert.message = "¡Inicia sesión con tu correo y contraseña!"
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            
            
            let vc = UIStoryboard.accounts.instantiate(SignInViewController.self)
            let wnd = UIApplication.shared.keyWindow
            var options = UIWindow.TransitionOptions()
            options.direction = .fade
            options.duration = 0.4
            options.style = .easeOut
            wnd?.setRootViewController(vc, options: options)
            
        })
        present(alert, animated: true)
        */
        
        //metemos el login por email
    }
    
    func signIn(with email: String, password: String) {
        showLoader(&loader, view: view)
        let user = User()
        user.email = email
        user.password = password
        user.loginRequest { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error)
            case .success(_):
                self?.performSuccessLogin()
            }
        }
    }
    
    private func performSuccessLogin() {
        let vc = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
        let wnd = UIApplication.shared.keyWindow
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        options.duration = 0.4
        options.style = .easeOut
        wnd?.setRootViewController(vc, options: options)
    }
}
