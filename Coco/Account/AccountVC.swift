//
//  AccountVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import AuthenticationServices
import JWTDecode

class AccountVC: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var appleSignIn: UIButton!
    
    var schoolId: String = ""
    var schools: Schools!
    var loader: LoaderVC!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        loginBtn.roundCorners(15)
        facebookBtn.roundCorners(15)
        appleSignIn.roundCorners(15)
        if #available(iOS 13.0,*) {
            print("The iOS version is 13 or newer")
        } else {
            appleSignIn.isHidden = true
        }
    }
    
    @IBAction func didTapAppleButton(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        } else {
            let alert = UIAlertController(title: "Error", message: "Esta funcionalidad solo está disponible en iOS 13 en adelante. Te invitamos a iniciar sesion o abrir tu cuenta con otra opción.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Intentar otra opción.", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction private func facebookLoginAction(_ sender: Any) {
        /*
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
         */
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
        let vc = instantiate(viewControllerClass: MainController.self)
        let wnd = UIApplication.shared.keyWindow
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        options.duration = 0.4
        options.style = .easeOut
        wnd?.setRootViewController(vc, options: options)
    }
    
    @IBAction private func loginAction(_ sender: Any) {
        let loginVC = instantiate(viewControllerClass: LoginVC.self)
        present(loginVC, animated: true)
    }
    
    @IBAction private func registerAction(_ sender: Any) {
        let registerVC = instantiate(viewControllerClass: RegisterVC.self)
        present(registerVC, animated: true)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let forgotPasswordVC = instantiate(viewControllerClass: ForgotPasswordVC.self)
        present(forgotPasswordVC, animated: true)
    }
}

extension AccountVC: SchoolModalDelegate {
    func didSelectSchool(index: Int) {
        schoolId = schools.schools[index].id ?? ""
        user.id_school = schoolId
        registerRequest()
    }
}

@available(iOS 13.0, *)
extension AccountVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
            let idToken = String(data: credentials.identityToken!, encoding: .utf8)
            let jwt = try! decode(jwt: idToken!)
            let userMail = jwt.claim(name: "email").string
            UserDefaults.standard.set(userMail!, forKey: "globalEmail")
            
            user = User(email: userMail!, password: userMail!)
            
            user.loginRequestFromApple { result in
                switch result {
                case .failure(let errorMssg):
                    if errorMssg == "Incorrect Password" {
                        print("Do the type 2 login")
                        self.user.newUserRequest2 { result in
                            switch result {
                            case .failure(let errorMssg):
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
                        let registerVC = self.instantiate(viewControllerClass: RegisterVC.self)
                        registerVC.emailFromApple = userMail!
                        registerVC.passwordFromApple = userMail!
                        self.present(registerVC, animated: true)
                    }
                case .success(_):
                    print("Succesful login will be performed.")
                    self.performSuccessLogin()
                }
            }
            
            //            if credentials.email != nil {
            //                print("This functions got activated because credentials are not nil")
            //                print(credentials.email)
            //                print(credentials.authorizationCode)
            //                let userValue = credentials.user
            //                let mailValue = credentials.email
            //                let nameValue = credentials.fullName?.givenName
            //                let lastNameValue = credentials.fullName?.familyName
            //                UserDefaults.standard.set(mailValue, forKey: "\(userValue)"+"Mail")
            //                UserDefaults.standard.set(nameValue, forKey: "\(userValue)"+"Name")
            //                UserDefaults.standard.set(mailValue, forKey: "\(userValue)"+"Password")
            //                UserDefaults.standard.set(true, forKey: "ComingFromAppleSignIn")
            //                UserDefaults.standard.set(true, forKey: "ComingFromAppleSignInPrompt")
            //                UserDefaults.standard.set(true, forKey: "ComingFromAppleSignInAlreadyExists")
            //                let registerVC = instantiate(viewControllerClass: RegisterVC.self)
            //                registerVC.nameFromApple = nameValue
            //                registerVC.emailFromApple = mailValue
            //                registerVC.surnameFromApple = lastNameValue
            //                registerVC.passwordFromApple = mailValue
            //                present(registerVC, animated: true)
            //            } else {
            //                UserDefaults.standard.set(true, forKey: "newUserHiddenMail")
            //                let idToken = String(data: credentials.identityToken!, encoding: .utf8)
            //                print(idToken)
            //                let jwt = try! decode(jwt: idToken!)
            //                let hiddenMail = jwt.claim(name: "email").string
            //
            //                UserDefaults.standard.set(hiddenMail!, forKey: "hiddenMail")
            //                let registerVC = instantiate(viewControllerClass: RegisterVC.self)
            //                registerVC.emailFromApple = hiddenMail
            //                registerVC.passwordFromApple = hiddenMail
            //                present(registerVC, animated: true)
            //
        //            }
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
extension AccountVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
