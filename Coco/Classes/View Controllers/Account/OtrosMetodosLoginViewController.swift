//
//  OtrosMetodosLoginViewController.swift
//  Coco
//
//  Created by Erick Monfil on 21/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import BottomPopup

class OtrosMetodosLoginViewController: BottomPopupViewController {

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    @IBOutlet weak var btnCrearCuenta: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnCrearCuenta.layer.cornerRadius = 20
    }
    
    override var popupHeight: CGFloat { height ?? 300.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    
    @IBAction func registroAction(_ sender: UIButton) {
        print("creando una cuenta")
        
        self.performSegue(withIdentifier: "sendToCrearCuenta", sender: self)
    }
    
    @IBAction func entrarComoInvitadoAction(_ sender: UIButton) {
        performSuccessLogin()
    }
    
    private func performSuccessLogin() {
        Constatns.LocalData.tipoLogin = ProviderType.invitado.rawValue
        let vc = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
        let wnd = UIApplication.shared.keyWindow
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        options.duration = 0.4
        options.style = .easeOut
        wnd?.setRootViewController(vc, options: options)
    }
}
