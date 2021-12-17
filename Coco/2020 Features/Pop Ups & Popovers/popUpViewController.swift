//
//  popUpViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 24/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {
    
    // MARK: Outlets
        
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var shareCode: UIButton!
    
    var referalCode : String?
    var typeOfInfo = UserDefaults.standard.value(forKey: "buttonPressed") as! String
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(shareTheCode), name: Notification.Name(rawValue: "shareCoco"), object: nil)
    }
    
    //MARK: Funcs
    
    func checkInfo() {
        if typeOfInfo == "Cocopoints" {
            shareCode.isHidden = true
            message.text = "Cocopoints es una nueva forma de pago, ahora por cada compra que realices se sumarán cocopoints a tu cuenta, con los cuales podrás adquirir más productos. ¡Cocopoints es la nueva forma de comprar!"
        }
        if typeOfInfo == "tuCodigo" {
            message.text = "¡Ahora compartir CocoApp te dará beneficios! Comparte tu código y colócalo en la sección de código promocional,y recibe saldo para seguir comprando."
        }
    }
    
    //MARK: Actions
    
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareTheCode() {
        let text = "¡Descarga Cocoapp y usa mi código para obtener saldo gratis en tu primera recarga! CODIGO: \(referalCode!) Descargala en: https://apps.apple.com/mx/app/coco-app/id1470991257?l=en"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareCode(_ sender: Any) {
        let text = "¡Descarga Cocoapp y usa mi código para obtener saldo gratis en tu primera recarga! CODIGO: \(referalCode!) Descargala en: https://apps.apple.com/mx/app/coco-app/id1470991257?l=en"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
