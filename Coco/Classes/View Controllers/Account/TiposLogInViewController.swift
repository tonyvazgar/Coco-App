//
//  TiposLogInViewController.swift
//  Coco
//
//  Created by Erick Monfil on 20/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import AuthenticationServices
import JWTDecode
import CryptoKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseAnalytics



enum ProviderType : String {
    case email
    case google
    case apple
    case invitado
}

class TiposLogInViewController: UIViewController {

    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var vistaApple: UIView!
    @IBOutlet weak var vistaGoogle: UIView!
    @IBOutlet weak var vistaEmail: UIView!
    
    
    var loader: LoaderVC!
    var currentNonce : String?
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnApple.layer.cornerRadius = 20
        btnGoogle.layer.cornerRadius = 20
        btnEmail.layer.cornerRadius = 20
        
        
        if #available(iOS 13, *) {
            print("This code only runs on iOS 15 and up")
            vistaApple.visibility = .visible
            vistaGoogle.visibility = .visible
        } else {
            print("This code only runs on iOS 14 and lower")
            vistaApple.visibility = .gone
            vistaGoogle.visibility = .gone
        }
        
        
    }
    
    
    // MARK: - Login apple
    @available(iOS 13.0, *)
    @IBAction func loginAppleAction(_ sender: UIButton) {
        
        
        currentNonce = randomNonceString()
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        request.nonce = sha256(currentNonce!)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    
    // MARK: login google
    @IBAction func loginGoogleAction(_ sender: UIButton) {
       // guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        
        
        let signInConfig = GIDConfiguration.init(clientID: "4899968219-36j7srntqp2s2ec37kjvk3r523ik817b.apps.googleusercontent.com")

        //let config = GIDConfiguration(clientID: signInConfig)
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [unowned self] user, error in

          if let error = error {
            // ...
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }
            
            guard let usera = user else { return }

                let emailAddress = usera.profile?.email

                let fullName = usera.profile?.name
                let givenName = usera.profile?.givenName
                let familyName = usera.profile?.familyName
            
            
            self.user = User(name: givenName ?? "", last_name: familyName ?? "", email: emailAddress ?? "", password: "", facebook_login: false)
            print("fullName: \(fullName)")
            print("givenName: \(givenName)")
            print("emailAddress: \(emailAddress)")
            
            Constatns.LocalData.emailgoogle = emailAddress ?? ""
            Constatns.LocalData.nombregoogle = givenName ?? ""
            Constatns.LocalData.apellidogoogle = familyName ?? ""
            self.mostrarTeminos(tipoLogin: "google")
            
            
            /*
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            entrarConFirebase(credential: credential)
             */
        }
    }
    
    // MARK: login email
    @IBAction func loginEmailAction(_ sender: UIButton) {
        
        let registerVC = UIStoryboard.accounts.instantiate(SignInViewController.self)
        
        //self.present(registerVC, animated: true, completion: nil)
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func entrarConFirebase(credential : AuthCredential){
        Auth.auth().signIn(with: credential){ [self] (resutl, error) in
            if error == nil {
                print("todo jalo bien con el login de google")
                print("\(resutl?.user.displayName ?? "")")
                print("\(resutl?.user.email ?? "")")
                
                let email = resutl?.user.email ?? ""
                let nombre = resutl?.user.displayName ?? "Google"
                let apellidos = ""
                user = User(name: nombre, last_name: apellidos, email: email, password: "", facebook_login: false)
                signInGoogle(email: email, nombre: nombre, apellidos: apellidos)
            }
            else {
                throwError(str: "Ocurrio un error mediante el login con google")
                print("error con login de google")
            }
            
        }
    }
    // MARK: crear cuenta
    @IBAction func unwindFromOtrosMetodosCrearCuenta( _ seg: UIStoryboardSegue) {
        DispatchQueue.main.async {
            let registerVC = UIStoryboard.accounts.instantiate(RegisterViewController.self)
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    @IBAction func unwindFromLoginAppple( _ seg: UIStoryboardSegue) {
        user = User(name: Constatns.LocalData.nombreapple, last_name: "", email: Constatns.LocalData.emailapple, password: "", facebook_login: false)
        
        
        signInApple(email: Constatns.LocalData.emailapple, nombre: Constatns.LocalData.nombreapple, apellidos: "")
    }
    
    @IBAction func unwindFromLoginGoogle( _ seg: UIStoryboardSegue) {
        signInGoogle(email: Constatns.LocalData.emailgoogle, nombre: Constatns.LocalData.nombregoogle, apellidos: Constatns.LocalData.apellidogoogle)
    }
    
    func signInGoogle(email email: String, nombre : String, apellidos : String) {
        showLoader(&loader, view: view)
        Analytics.logEvent("Login google", parameters: [AnalyticsParameterItemID:"\(email)",AnalyticsParameterItemName:"\(nombre) \(apellidos)", AnalyticsParameterContentType:"ios google"])
        user.loginRequestGoogle(email: email, nombre: nombre, apellidos: apellidos) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error)
            case .success(_):
                self?.performSuccessLogin()
            }
        }
    }
    
    func signInApple(email email: String, nombre : String, apellidos : String) {
        showLoader(&loader, view: view)
        user.loginRequestApple(email: email, nombre: nombre, apellidos: apellidos) { [weak self] result in
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
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // MARK: Otros metodos action
    @IBAction func otrosMetodosAction(_ sender: UIButton) {
        guard let popupViewController = storyboard?.instantiateViewController(withIdentifier: "OtrosMetodosLoginViewController") as? OtrosMetodosLoginViewController else { return }
        popupViewController.height = 350
        popupViewController.topCornerRadius = 35
        popupViewController.presentDuration = 0.5
        popupViewController.dismissDuration = 0.5
        popupViewController.shouldDismissInteractivelty = true
        //popupViewController.popupDelegate = self
        present(popupViewController, animated: true, completion: nil)
    }
    
    
    //MARK: Terminos method
    func mostrarTeminos(tipoLogin : String){
        guard let popupViewController = storyboard?.instantiateViewController(withIdentifier: "TerminosPopUpViewController") as? TerminosPopUpViewController else { return }
        popupViewController.tipoLogin = tipoLogin
        popupViewController.height = 350
        popupViewController.topCornerRadius = 35
        popupViewController.presentDuration = 0.5
        popupViewController.dismissDuration = 0.5
        popupViewController.shouldDismissInteractivelty = true
        //popupViewController.popupDelegate = self
        present(popupViewController, animated: true, completion: nil)
    }
    
}

@available(iOS 13.0, *)
extension TiposLogInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        
        if let nonce = currentNonce,let appleIdCredentials = authorization.credential as? ASAuthorizationAppleIDCredential, let appleIdToken = appleIdCredentials.identityToken,let appleIdTokenString = String(data: appleIdToken, encoding: .utf8){
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

                print("User ID: \(appleIDCredential.user)")

                if let userEmail = appleIDCredential.email {
                  print("Email: \(userEmail)")
                    Constatns.LocalData.emailapple = userEmail
                }

                if let userGivenName = appleIDCredential.fullName?.givenName,
                  let userFamilyName = appleIDCredential.fullName?.familyName {
                  print("Given Name: \(userGivenName)")
                  print("Family Name: \(userFamilyName)")
                    
                }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIdTokenString, rawNonce: nonce)
            
            print("El AppleIDTokenString es: ")
            print(appleIdTokenString)
            let jwt = try? decode(jwt: appleIdTokenString)
            print("El jwt es: ")
            print(jwt)
            let userMail = jwt?.claim(name: "email").string
            let userName = jwt?.claim(name: "fullName").string
            print("nombre jwt:\(userName)")
            print("Email:\(userMail)")
            
            if Constatns.LocalData.emailapple == "" {
                Constatns.LocalData.emailapple = userMail ?? ""
            }
            else {
                let mailnuevo = userMail ?? ""
                if mailnuevo != "" {
                    if Constatns.LocalData.emailapple != userMail {
                        Constatns.LocalData.emailapple = mailnuevo
                    }
                }
                
            }
            print("nombrecompleto :\(appleIdCredentials.fullName)")
            print("nombre:\(appleIdCredentials.fullName?.givenName ?? "")")
            print("apellidos:\(appleIdCredentials.fullName?.familyName ?? "")")
            
            let givName : String = appleIdCredentials.fullName?.givenName ?? ""
            
            if givName != "" {
                Constatns.LocalData.nombreapple = "\(appleIdCredentials.fullName?.givenName ?? "") \(appleIdCredentials.fullName?.familyName ?? "")"
            }
            
            
            
            Auth.auth().signIn(with: credential){ [self] (resutl, error) in
                
                if error == nil {
                    print("todo jalo bien con el login de apple")
                    mostrarTeminos(tipoLogin: "apple")
                    
                }
                else{
                    throwError(str: "Ocurrio un error mediante el login con Apple")
                }
                
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
    /*
     func presentarModal(){
         guard let popupViewController = storyboard?.instantiateViewController(withIdentifier: "YaLLegueViewController") as? YaLLegueViewController else { return }
         popupViewController.height = 350
         popupViewController.topCornerRadius = 35
         popupViewController.presentDuration = 0.5
         popupViewController.dismissDuration = 0.5
         popupViewController.shouldDismissInteractivelty = true
         //popupViewController.popupDelegate = self
         present(popupViewController, animated: true, completion: nil)
     }
     */
}

@available(iOS 13.0, *)
extension TiposLogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}


