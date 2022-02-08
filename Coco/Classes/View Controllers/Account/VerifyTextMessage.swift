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
    
    @IBAction func verifyButtonAction(_ sender: Any) {
        
        guard let code = validateField(textMessageField) else {
            throwError(str: "Para continuar debes ingresar el código.")
            return
        }
        
        view.resignFirstResponder()
        showLoader(&loader, view: view)
        
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
        
    }
}
