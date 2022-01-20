//
//  RegisterViewController.swift
//  Coco
//
//  Created by Carlos Banos on 9/28/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import DropDown
import M13Checkbox
import SkyFloatingLabelTextField
import SafariServices

class RegisterViewController: UIViewController {
    
    @IBOutlet private var topBar: UIView!
    
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var lastNameField: UITextField!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var phoneField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var confirmPasswordField: UITextField!
    @IBOutlet private var registerBtn: UIButton!
    @IBOutlet private var termsSwitch: UISwitch!
    @IBOutlet private var cityInputLabel: UILabel!
    @IBOutlet weak var terminosYcondiciones: UILabel!
    
    private var cityDropDown: DropDown = DropDown()
    
    private var cities: [CityDataModel] = []
    
    var nameFromApple : String!
    var emailFromApple : String?
    var surnameFromApple : String!
    var passwordFromApple : String!
    
    var schoolId: String?
    var schools: Schools!
    var loader: LoaderVC!
    var user: User!
    
    private var selectedCityId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        comingFrom()
        configureView()
        fetchCities()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let email = emailFromApple, let name = nameFromApple else { return }
        emailField.text = email
        nameField.text = name
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "ComingFromAppleSignInPrompt") == true {
//            let alert = UIAlertController(title: "¡Hola!", message: "Parece que estás creando una cuenta nueva. ¡Solo faltan unos pasos para disfrutar de Coco APP! Por favor selecciona tu institución. No te olvides de leer y aceptar los términos y condiciones.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Elegir institución", style: .default, handler: nil))
//            self.present(alert, animated: true)
//            UserDefaults.standard.set(false, forKey: "ComingFromAppleSignInPrompt")
//        }
//        if UserDefaults.standard.bool(forKey: "newUserHiddenMail") == true {
//            let alert = UIAlertController(title: "¡Hola!", message: "Parece que estás creando una cuenta nueva. ¡Solo faltan unos pasos para disfrutar de Coco APP! Por favor rellena los campos vacios. No te olvides de leer y aceptar los términos y condiciones.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Llenar campos faltantes", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        }
//    }
    
//    private func comingFrom() {
//        if UserDefaults.standard.bool(forKey: "ComingFromAppleSignIn") == true {
//            nameField.isUserInteractionEnabled = false
//            emailField.isUserInteractionEnabled = false
//            lastNameField.isUserInteractionEnabled = false
//            passwordField.isUserInteractionEnabled = false
//            nameField.alpha = 0.5
//            emailField.alpha = 0.5
//            lastNameField.alpha = 0.5
//            passwordField.alpha = 0.5
//            nameField.text = nameFromApple
//            emailField.text = emailFromApple
//            lastNameField.text = surnameFromApple
//            passwordField.text = passwordFromApple
//
//            UserDefaults.standard.set(false, forKey: "ComingFromAppleSignIn")
//        }
//        if UserDefaults.standard.bool(forKey: "newUserHiddenMail") == true {
//            emailField.isUserInteractionEnabled = false
//            passwordField.isUserInteractionEnabled = false
//            emailField.text = emailFromApple
//            passwordField.text = passwordFromApple
//        }
//    }
    
    @IBAction private func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func registerBtnAction(_ sender: Any) {
        guard let name = validateField(nameField),
              let last_name = validateField(lastNameField),
              let phone = validateField(phoneField),
              let email = validateField(emailField),
              let city = selectedCityId,
              let password = validateField(passwordField),
              let confirmPassword = validateField(confirmPasswordField) else {
            throwError(str: "Para continuar debes completar todos los campos.")
            return
        }
        
        if !isValidEmail(email) {
            throwError(str: "Para continuar debes ingresar un email válido.")
            return
        }
        
        if password != confirmPassword {
            throwError(str: "Las contraseñas no coinciden.")
            return
        }
        
        if !termsSwitch.isOn {
            throwError(str: "Para continuar debes aceptar los términos y condiciones")
            return
        }
        
        view.resignFirstResponder()
        showLoader(&loader, view: view)
        
        user = User()
        user.name = name
        user.last_name = last_name
        user.phone = phone
        user.email = email
        user.password = password

        user.newUserRequest(id_city: city) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self?.throwError(str: errorMssg)
            case .success(_):
                self?.performSuccessRegister()
            }
        }
//        if UserDefaults.standard.bool(forKey: "newUserHiddenMail") == true {
//
//            UserDefaults.standard.set(false, forKey: "newUserHiddenMail")
//            return
//        }
//
//
//        guard let name = nameField,
//            let last_name = lastNameField,
//            let email = emailField,
//            let password = passwordField,
//            let confirmPassword = confirmPasswordField
//            else { return }
//
//        if !termsSwitch.isOn {
//            throwError(str: "Para continuar debes aceptar los términos y condiciones")
//            return
//        }
//        view.resignFirstResponder()
//        showLoader(&loader, view: view)
//        user = User(name: name, last_name: last_name, phone: phone, email: email, password: password, facebook_login: false, id_school: school)
//
//        user.newUserRequest { result in
//            self.loader.removeAnimate()
//            switch result {
//            case .failure(let errorMssg):
//
//                if UserDefaults.standard.bool(forKey: "ComingFromAppleSignInAlreadyExists") == true {
//
//                    self.user.newUserRequest2 { result in
//                        self.loader.removeAnimate()
//                        switch result {
//                        case .failure(let errorMssg):
//                            print("This shit failed")
//                        case .success(_):
//                            self.performSuccessRegister()
//                            print("We might be getting somewhere.")
//                        }
//                    }
//
//                }
//
//            case .success(_):
//                self.performSuccessRegister()
//            }
//        }
    }

    private func performSuccessRegister() {
        let alert = UIAlertController()
        alert.title = "Cuenta creada con éxito"
        alert.message = "¡Favor de revisar su correo para validar su cuenta!"
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
//
//        self.present(errorAlert, animated: true, completion: nil)
//        guard let id = user.id else { return }
//        UserDefaults.standard.set(id, forKey: "id_user")
//        let vc = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
//        let wnd = UIApplication.shared.keyWindow
//        var options = UIWindow.TransitionOptions()
//        options.direction = .fade
//        options.duration = 0.4
//        options.style = .easeOut
//        wnd?.setRootViewController(vc, options: options)
    }
    
    private func performSuccessLogin() {
        guard let id = user.id else { return }
        UserDefaults.standard.set(id, forKey: "id_user")
        let vc = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
        let wnd = UIApplication.shared.keyWindow
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        options.duration = 0.4
        options.style = .easeOut
        wnd?.setRootViewController(vc, options: options)
    }
    
    private func btnTermsAction() {
        guard let url = URL(string: "http://easycode.mx/sistema_coco/aviso/terminos.pdf") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    private var eyeButton: UIButton = {
        let button = UIButton()
        let templateImage = UIImage(named: "password_eye")?.withRenderingMode(.alwaysTemplate)
        button.setImage(templateImage, for: .normal)
        button.addTarget(self, action: #selector(revealPasswordField), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.tintColor = .black
        return button
    }()
    
    private var eyeButton2: UIButton = {
        let button = UIButton()
        let templateImage = UIImage(named: "password_eye")?.withRenderingMode(.alwaysTemplate)
        button.setImage(templateImage, for: .normal)
        button.addTarget(self, action: #selector(revealPasswordConfirmationField), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.tintColor = .black
        return button
    }()
    
    private func validateField(_ textField: UITextField) -> String? {
        (textField.text?.isEmpty ?? true) ? nil : textField.text
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - Cities

private extension RegisterViewController {
    func fetchCities() {
        CitiesFetcher.fetchCities { [weak self] result in
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let cities):
                self?.cities = cities
                self?.configureDropdown()
            }
        }
    }
    
    func configureDropdown() {
        cityDropDown.anchorView = cityInputLabel
        cityDropDown.dataSource = cities.map { $0.name }
        cityDropDown.direction = .any
        cityDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectedCityId = self?.cities[index].id
            self?.cityInputLabel.text = item
            self?.cityDropDown.hide()
        }
    }
    
    @objc func openDropdown() {
        cityDropDown.show()
    }
    @objc func linktYc() {
        if let url = URL(string: "http://cocosinfilas.com/TandC.pdf") {
//            UIApplication.shared.open(url)
            present(SFSafariViewController(url: url), animated: true)
        }
    }
}

// MARK: - Configure View

private extension RegisterViewController {
    func configureView() {
        registerBtn.roundCorners(16)
        configureTextFields()
        configurePasswordFields()
        cityInputLabel.addTap(#selector(openDropdown), tapHandler: self)
        
        terminosYcondiciones.addTap(#selector(linktYc), tapHandler: self)
        
    }
    
    func configureTextFields() {
        nameField.clipsToBounds = true
        lastNameField.clipsToBounds = true
        emailField.clipsToBounds = true
        phoneField.clipsToBounds = true
        passwordField.clipsToBounds = true
        confirmPasswordField.clipsToBounds = true
        
        nameField.addBottomBorder(thickness: 1, color: .lightGray)
        lastNameField.addBottomBorder(thickness: 1, color: .lightGray)
        emailField.addBottomBorder(thickness: 1, color: .lightGray)
        phoneField.addBottomBorder(thickness: 1, color: .lightGray)
        passwordField.addBottomBorder(thickness: 1, color: .lightGray)
        confirmPasswordField.addBottomBorder(thickness: 1, color: .lightGray)
        cityInputLabel.addBottomBorder(thickness: 1, color: .lightGray)
    }
    
    func configurePasswordFields() {
        passwordField.rightView = eyeButton
        confirmPasswordField.rightView = eyeButton2
        passwordField.rightViewMode = .always
        confirmPasswordField.rightViewMode = .always
    }
    
    @objc func revealPasswordField() {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        eyeButton.tintColor = passwordField.isSecureTextEntry ? .black : .cocoOrange
    }
    
    @objc func revealPasswordConfirmationField() {
        confirmPasswordField.isSecureTextEntry = !confirmPasswordField.isSecureTextEntry
        eyeButton2.tintColor = confirmPasswordField.isSecureTextEntry ? .black : .cocoOrange
    }
}
