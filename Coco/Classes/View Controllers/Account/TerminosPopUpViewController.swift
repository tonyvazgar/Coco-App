//
//  TerminosPopUpViewController.swift
//  Coco
//
//  Created by Erick Monfil on 24/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import BottomPopup
import SafariServices

class TerminosPopUpViewController: BottomPopupViewController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    @IBOutlet weak var btnAceptar: UIButton!
    
    var tipoLogin : String = "" //apple, google
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnAceptar.layer.cornerRadius = 20
    }
    

    override var popupHeight: CGFloat { height ?? 300.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }

    @IBAction func openTerminosAction(_ sender: UIButton) {
        if let url = URL(string: "http://cocosinfilas.com/TandC.pdf") {
//            UIApplication.shared.open(url)
            present(SFSafariViewController(url: url), animated: true)
        }
    }
    
    @IBAction func aceptoTerminosAction(_ sender: UIButton) {
        if tipoLogin == "apple" {
            self.performSegue(withIdentifier: "backLoginApple", sender: self)
        }
        if tipoLogin == "google" {
            self.performSegue(withIdentifier: "backLoginGoogle", sender: self)
        }
        
    }
}
