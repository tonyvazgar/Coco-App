//
//  SignInViewController.swift
//  Coco
//
//  Created by Carlos Banos on 9/28/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices
import JWTDecode

final class SignInViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var forgotPasswordButton: UIButton!
    @IBOutlet private var signInButton: UIButton!
    @IBOutlet private var registerTextView: UITextView!
    
    // MARK: Social networks login
    @IBOutlet private var appleSignIn: UIButton!
    @IBOutlet private var googleSignIn: UIButton!
    @IBOutlet private var facebookSignIn: UIButton!
    
    var loader: LoaderVC!
    
    var schoolId: String = ""
    var schools: Schools!
    
    var user: User!
    
    private var eyeButton: UIButton = {
        let eyeButton = UIButton()
        let templateImage = UIImage(named: "password_eye")?.withRenderingMode(.alwaysTemplate)
        eyeButton.setImage(templateImage, for: .normal)
        eyeButton.addTarget(self, action: #selector(revealPasswordField), for: .touchUpInside)
        eyeButton.imageView?.contentMode = .scaleAspectFit
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        eyeButton.tintColor = .black
        return eyeButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction private func facebookLoginAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    guard error == nil,
                        let data = result as? Dictionary<String,Any>,
                        let fb_id = data["id"] as? String,
                        let email = data["email"] as? String,
                        let first_name = data["first_name"] as? String,
                        let last_name = data["last_name"] as? String else {
                            self.throwError(str: "No se pudieron obtener los datos de Facebook")
                            return
                    }
                    self.performFBLogin(email: email, name: first_name, last_name: last_name, fb_id: fb_id)
            })
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
    
    private func performFBLogin(email: String, name: String, last_name: String, fb_id: String) {
        user = User(name: name, last_name: last_name, email: email, password: fb_id, facebook_login: true)
        requestSchools()
    }
    
    private func registerRequest() {
        showLoader(&loader, view: view)
        user.newUserRequest { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.performSuccessRegister()
            }
        }
    }
    
    private func requestSchools() {
        schools = Schools()
        showLoader(&loader, view: view)
        schools.getSchoolsRequest { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.showSchoolPicker()
            }
        }
    }
    
    private func showSchoolPicker() {
        let vc = SchoolModal()
        vc.schools = schools
        vc.delegate = self
        addChild(vc)
        vc.showInView(aView: view, animated: true)
    }
    
    private func performSuccessRegister() {
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
    
    // MARK: IBActions
    @IBAction private func loginAction(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty else {
            throwError(str: "Favor de ingresar todos los datos para continuar.")
            return
        }
        signIn(with: email, password: password)
    }
    
    @IBAction private func googleSignInAction(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction private func facebookSignInAction(_ sender: Any) {
        
    }
    
    @IBAction private func forgotPassword(_ sender: Any) {
        let forgotPasswordVC = UIStoryboard.accounts.instantiate(ForgotPasswordVC.self)
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @IBAction private func didTapAppleButton(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
            
//            VER LOGICA PARA LOGIN CON APPLE
            
        }
    }
}

// MARK: - Network Requests

private extension SignInViewController {
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
}

// MARK: - Configure View

private extension SignInViewController {
    func configureView() {
        configureButtons()
        configureRegisterTextView()
        configureTextFields()
        configurePasswordTextField()
        guard #available(iOS 13.0,*) else { return }
        appleSignIn.isHidden = true
        facebookSignIn.isHidden = true
        googleSignIn.isHidden = true
    }
    
    func configureButtons() {
        signInButton.roundCorners(16)
        appleSignIn.roundCorners(16)
        facebookSignIn.roundCorners(16)
        googleSignIn.roundCorners(16)
    }
    
    func configureRegisterTextView() {
        let attributtedString = NSMutableAttributedString()
        let firstString = NSAttributedString(string: "No tienes cuenta, ",
                                             attributes: [
                                                .font: UIFont.poppins(type: .medium, size: 14),
                                                .foregroundColor: UIColor.cocoGray])
        let secondString = NSAttributedString(string: "REGISTRATE AQUÍ.",
                                              attributes: [
                                                .font: UIFont.poppins(type: .bold, size: 14),
                                                .foregroundColor: UIColor.cocoOrange,
                                                .link: NSURL(string: "coco://register")!])
        attributtedString.append(firstString)
        attributtedString.append(secondString)
        UITextView.appearance().linkTextAttributes = [ .foregroundColor: UIColor.cocoOrange ]
        registerTextView.delegate = self
        registerTextView.attributedText = attributtedString
        registerTextView.textAlignment = .center
    }
    
    func configureTextFields() {
        emailTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        emailTextField.addBottomBorder(thickness: 1, color: .lightGray)
        passwordTextField.addBottomBorder(thickness: 1, color: .lightGray)
    }
    
    func configurePasswordTextField() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func revealPasswordField() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        eyeButton.tintColor = passwordTextField.isSecureTextEntry ? .black : .cocoOrange
    }
}

extension SignInViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let registerVC = UIStoryboard.accounts.instantiate(RegisterViewController.self)
        navigationController?.pushViewController(registerVC, animated: true)
        return false
    }
}

extension SignInViewController: SchoolModalDelegate {
    func didSelectSchool(index: Int) {
        schoolId = schools.schools[index].id ?? ""
        user.id_school = schoolId
        registerRequest()
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let idToken = String(data: credentials.identityToken!, encoding: .utf8)
            print("El AppleIDTokenString es: ")
            print(idToken)
            let jwt = try? decode(jwt: idToken!)
            print("El jwt es: ")
            print(jwt)
            let userMail = jwt?.claim(name: "email").string
            let userName = jwt?.claim(name: "fullName").string
            
            user = User(name: userName ?? "Brrr", email: userMail ?? "", password: userMail ?? "")
            
            user.loginRequestFromApple { result in
                switch result {
                case .failure(let errorMssg):
                    if errorMssg == "Incorrect Password" {
                        print("Do the type 2 login")
                        self.user.newUserRequest2 { result in
                            switch result {
                            case .failure(_):
                                print("This shit failed")
                            case .success(_):
                                self.performSuccessRegister()
                                print("We might be getting somewhere.")
                            }
                        }
                    }
                    if errorMssg == "User not found" {
                        UserDefaults.standard.set(true, forKey: "newUserHiddenMail")
                        UserDefaults.standard.set(userMail!, forKey: "hiddenMail")
                        let registerVC = self.instantiate(viewControllerClass: RegisterViewController.self)
                        registerVC.emailFromApple = userMail!
//                        registerVC.nameFromApple = "userName"
//                        registerVC.passwordFromApple = userMail!
                        self.present(registerVC, animated: true)
                    }
                case .success(_):
                    print("Succesful login will be performed.")
                    self.performSuccessLogin()
                }
            }
        case let passwordCredential as ASPasswordCredential:
            print("This happened, the passwordCredential")
            print(passwordCredential.password)
        default:break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
    
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
